module "app" {
  source = "../../"

  apps = [
    {
      name       = "keydb"
      namespace  = "keydb"
      chart      = "keydb"
      repository = "https://enapter.github.io/charts"
      version    = "0.35.0"
      sync_wave  = -5
      project    = "aweasome-project"
      cluster    = "in-cluster"
      values = yamlencode(
        {
          fullnameOverride = "keydb"
        }
      )
      max_history = 5
    }
  ]

  name      = "aweasome"
  stage     = "production"
  namespace = "rallyware"
}
