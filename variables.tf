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
            repository = optional(string)
            chart      = optional(string)
            version    = optional(string)
          }
        ),
        {
          repository = "https://rallyware.github.io/terraform-argocd-apps"
          chart      = "argocd-app-of-apps"
          version    = "0.1.0"
        }
      )

      timeouts = optional(
        object(
          {
            create = optional(string)
            update = optional(string)
            delete = optional(string)
          }
        ),
        {
          create = "60m"
          update = "60m"
          delete = "60m"
        }
      )

      retry = optional(
        object(
          {
            limit                = optional(number)
            backoff_duration     = optional(string)
            backoff_max_duration = optional(string)
            backoff_factor       = optional(number)
          }
        ),
        {
          limit                = 0
          backoff_duration     = "30s"
          backoff_max_duration = "1m"
          backoff_factor       = 2
        }
      )

      destination = optional(
        object(
          {
            name      = optional(string)
            namespace = optional(string)
          }
        ),
        {
          name      = "in-cluster"
          namespace = "argo"
        }
      )

      automated = optional(
        object(
          {
            prune       = optional(bool)
            self_heal   = optional(bool)
            allow_empty = optional(bool)
          }
        ),
        {
          prune       = true
          self_heal   = true
          allow_empty = true
        }
      )
    }
  )
  description = "A parent app configuration."
}

variable "apps" {
  type = list(object(
    {
      name        = string
      repository  = string
      version     = string
      cluster     = string
      project     = string
      namespace   = optional(string, "default")
      chart       = optional(string, "")
      path        = optional(string, "")
      values      = optional(string, "")
      skip_crds   = optional(bool, false)
      value_files = optional(list(string), [])
      max_history = optional(number, 10)
      sync_wave   = optional(number, 50)
      annotations = optional(map(string), {})
      ignore_differences = optional(
        list(object(
          {
            group             = optional(string)
            kind              = optional(string)
            jqPathExpressions = optional(list(string))
            jsonPointers      = optional(list(string))
          }
        ))
      )
      sync_options = optional(list(string), ["CreateNamespace=true", "ApplyOutOfSyncOnly=true"])

      retry = optional(
        object(
          {
            limit                = optional(number)
            backoff_duration     = optional(string)
            backoff_max_duration = optional(string)
            backoff_factor       = optional(number)
          }
        ),
        {
          limit                = 0
          backoff_duration     = "30s"
          backoff_max_duration = "1m"
          backoff_factor       = 2
        }
      )

      automated = optional(
        object(
          {
            prune       = optional(bool)
            self_heal   = optional(bool)
            allow_empty = optional(bool)
          }
        ),
        {
          prune       = true
          self_heal   = true
          allow_empty = true
        }
      )

      managed_namespace_metadata = optional(
        object(
          {
            labels      = optional(map(string))
            annotations = optional(map(string))
          }
      ), {})
    }
  ))
}
