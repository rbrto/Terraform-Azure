# Create AKS Cluster
module "aks_stage" {
  source                 = "../modules/aks"
  name                   = var.project_name
  environment            = var.environment
  resource_group_name    = var.resource_group
  location               = var.location
  client_id              = var.client_id
  client_secret          = var.client_secret
  aks_subnet_id          = azurerm_subnet.aks.id
  aks_kubernetes_version = var.aks_kubernetes_version
  aks_svl_namespaces     = var.aks_svl_namespaces
  agent_pools            = var.agent_pools
  network_profile        = var.network_profile
}

# Set Up Tiller
module "aks_tiller" {
  source                 = "../modules/tiller"
  tiller_net_host        = var.tiller_net_host
  tiller_replicas        = var.tiller_replicas
  tiller_version         = var.tiller_version
  tiller_namespace       = var.tiller_namespace
  tiller_node_selector   = var.tiller_node_selector
  tiller_image           = var.tiller_image
  tiller_service_account = var.tiller_service_account
  tiller_max_history     = var.tiller_max_history
}

# Create Ingress K8s Ip
resource "azurerm_public_ip" "svl-ip" {
  name                = "${var.project_name}-ingress-ip"
  location            = var.location
  resource_group_name = var.resource_group
  allocation_method   = "Static"
  sku                 = "Standard"
  tags = {
    environment = var.environment
  }

  depends_on = [module.aks_stage]
}

# Install Azure Key Vault Controller
resource "helm_release" "key-vault-controller" {
  name      = "key-vault-controller"
  namespace = "default"

  repository = "https://charts.spvapi.no"
  chart      = "azure-key-vault-controller"

  set {
    name  = "installCrd"
    value = "false"
  }
}

# Install Azure Key Vault Injector
resource "helm_release" "key-vault-injector" {
  name      = "key-vault-injector"
  namespace = "default"

  repository = "https://charts.spvapi.no"
  chart      = "azure-key-vault-env-injector"
}