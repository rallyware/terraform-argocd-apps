terraform {
  required_version = ">= 1.3.7"

  required_providers {
    argocd = {
      source  = "oboukili/argocd"
      version = ">= 1.2"
    }
  }
}
