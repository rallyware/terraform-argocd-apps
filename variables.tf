variable "parent_app" {
  type = object(
    {
      name         = string
      namespace    = optional(string, "argo")
      annotations  = optional(map(string))
      project      = optional(string)
      wait         = optional(bool, false)
      sync_options = optional(list(string), ["CreateNamespace=true", "ApplyOutOfSyncOnly=true"])

      helm = optional(
        object(
          {
            repository = optional(string, "https://rallyware.github.io/terraform-argocd-apps")
            chart      = optional(string, "argocd-app-of-apps")
            version    = optional(string, "0.1.0")
          }
      ), {})

      timeouts = optional(
        object(
          {
            create = optional(string, "60m")
            update = optional(string, "60m")
            delete = optional(string, "60m")
          }
      ), {})

      retry = optional(
        object(
          {
            limit                = optional(number, 0)
            backoff_duration     = optional(string, "30s")
            backoff_max_duration = optional(string, "1m")
            backoff_factor       = optional(number, 2)
          }
      ), {})

      destination = optional(
        object(
          {
            name      = optional(string, "in-cluster")
            namespace = optional(string, "argo")
          }
      ), {})

      automated = optional(
        object(
          {
            prune       = optional(bool, true)
            self_heal   = optional(bool, true)
            allow_empty = optional(bool, true)
          }
      ), {})
    }
  )
  description = "A parent app configuration."
}

variable "apps" {
  type = list(object(
    {
      name         = string
      repository   = string
      version      = string
      cluster      = optional(string, "in-cluster")
      project      = string
      namespace    = optional(string, "default")
      chart        = optional(string, "")
      path         = optional(string, "")
      values       = optional(string, "")
      skip_crds    = optional(bool, false)
      value_files  = optional(list(string), [])
      max_history  = optional(number, 10)
      sync_wave    = optional(number, 50)
      annotations  = optional(map(string), {})
      sync_options = optional(list(string), ["CreateNamespace=true", "ApplyOutOfSyncOnly=true"])

      ignore_differences = optional(
        list(object(
          {
            group             = optional(string)
            kind              = optional(string)
            jqPathExpressions = optional(list(string))
            jsonPointers      = optional(list(string))
          }
      )), null)

      retry = optional(
        object(
          {
            limit                = optional(number, 0)
            backoff_duration     = optional(string, "30s")
            backoff_max_duration = optional(string, "1m")
            backoff_factor       = optional(number, 2)
          }
      ), {})

      automated = optional(
        object(
          {
            prune       = optional(bool, true)
            self_heal   = optional(bool, true)
            allow_empty = optional(bool, true)
          }
      ), {})

      managed_namespace_metadata = optional(
        object(
          {
            labels      = optional(map(string))
            annotations = optional(map(string))
          }
      ), null)
    }
  ))
  description = "A list of ArgoCD applications to deploy."
}
