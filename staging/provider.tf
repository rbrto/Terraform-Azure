provider "azuread" {
  version = "~> 0.3"
}

provider "kubernetes" {
  version                = "1.7.0"
  load_config_file       = false
  host                   = module.aks_stage.host
  client_certificate     = base64decode(module.aks_stage.client_certificate)
  client_key             = base64decode(module.aks_stage.client_key)
  cluster_ca_certificate = base64decode(module.aks_stage.cluster_ca_certificate)
}

provider "helm" {
  install_tiller  = true
  service_account = module.aks_tiller.service_account
  namespace       = module.aks_tiller.namespace

  kubernetes {
    host                   = module.aks_stage.host
    client_certificate     = base64decode(module.aks_stage.client_certificate)
    client_key             = base64decode(module.aks_stage.client_key)
    cluster_ca_certificate = base64decode(module.aks_stage.cluster_ca_certificate)
  }
}