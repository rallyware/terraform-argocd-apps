locals {
  enabled = module.this.enabled
  apps    = local.enabled ? var.apps : []

  argocd_helm_apps_value = {
    applications = [for app in local.apps :
      {
        name                     = module.apps_label[app.name].id
        namespace                = app.namespace
        chart                    = app.chart
        repoURL                  = app.repository
        path                     = app.path
        targetRevision           = app.version
        syncWave                 = app.sync_wave
        values                   = app.values
        releaseName              = app.name
        annotations              = app.annotations
        ignoreDifferences        = app.ignore_differences != null ? app.ignore_differences : []
        clusterName              = app.cluster
        projectName              = app.project
        syncOptions              = app.sync_options
        skipCrds                 = app.skip_crds
        valueFiles               = app.value_files
        managedNamespaceMetadata = app.managed_namespace_metadata
        retry                    = app.retry
        revisionHistoryLimit     = app.max_history
        omitFinalizer            = app.omit_finalizer

        automated = {
          prune      = app.automated.prune
          selfHeal   = app.automated.self_heal
          allowEmpty = app.automated.allow_empty
        }
      }
    ]
  }
}

module "apps_label" {
  for_each = { for app in local.apps : app.name => app }

  source  = "cloudposse/label/null"
  version = "0.25.0"

  name    = each.key
  context = module.this.context
}

resource "argocd_application" "apps" {
  count = local.enabled ? 1 : 0

  metadata {
    name        = var.parent_app["name"]
    namespace   = var.parent_app["namespace"]
    labels      = module.this.tags
    annotations = var.parent_app["annotations"]
  }

  wait = var.parent_app["wait"]

  spec {
    project = var.parent_app["project"]

    source {
      repo_url        = var.parent_app["helm"]["repository"]
      chart           = var.parent_app["helm"]["chart"]
      target_revision = var.parent_app["helm"]["version"]

      helm {
        values       = yamlencode(local.argocd_helm_apps_value)
        release_name = var.parent_app["name"]
      }
    }

    destination {
      name      = var.parent_app["destination"]["name"]
      namespace = var.parent_app["destination"]["namespace"]
    }

    sync_policy {
      automated {
        prune       = var.parent_app["automated"]["prune"]
        self_heal   = var.parent_app["automated"]["self_heal"]
        allow_empty = var.parent_app["automated"]["allow_empty"]
      }

      sync_options = var.parent_app["sync_options"]

      dynamic "retry" {
        for_each = var.parent_app["retry"]["limit"] > 0 ? [1] : []

        content {
          limit = var.parent_app["retry"]["limit"]

          backoff {
            duration     = var.parent_app["retry"]["backoff_duration"]
            max_duration = var.parent_app["retry"]["backoff_max_duration"]
            factor       = var.parent_app["retry"]["backoff_factor"]
          }
        }
      }
    }
  }

  timeouts {
    create = var.parent_app["timeouts"]["create"]
    update = var.parent_app["timeouts"]["update"]
    delete = var.parent_app["timeouts"]["delete"]
  }
}
