terraform {
  required_version = ">= 1.3"

  required_providers {
    argocd = {
      source  = "oboukili/argocd"
      version = "< 6.1"
    }
  }
}
