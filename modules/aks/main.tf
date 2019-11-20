# Create managed Kubernetes cluster (AKS)
resource "azurerm_kubernetes_cluster" "aks" {
  name                = "${var.name}-${var.environment}"
  location            = var.location
  resource_group_name = var.resource_group_name
  dns_prefix          = "${var.name}-${var.environment}"
  kubernetes_version  = var.aks_kubernetes_version


  dynamic "agent_pool_profile" {
    for_each = var.agent_pools
    iterator = pool
    content {
      name            = pool.value.name
      count           = pool.value.count
      vm_size         = pool.value.vm_size
      os_type         = pool.value.os_type
      os_disk_size_gb = pool.value.os_disk_size_gb
      vnet_subnet_id  = var.aks_subnet_id
    }
  }

  addon_profile {
    http_application_routing {
      enabled = false
    }
  }

  role_based_access_control {
     enabled = true

    #  azure_active_directory {
    #   client_app_id     = "XXXXXXXXXXXXXXXX"
    #   server_app_id     = "XXXXXXXXXXXXXXXX"
    #   server_app_secret = "XXXXXXXXXXXXXXXX"
    #   tenant_id         = "XXXXXXXXXXXXXXXX"
    # }
  }

  # Enable Advanced Networking
  network_profile {
    network_plugin     = var.network_profile.network_plugin
    service_cidr       = var.network_profile.service_cidr
    dns_service_ip     = var.network_profile.dns_service_ip # Containers DNS server IP address
    docker_bridge_cidr = var.network_profile.docker_bridge_cidr # A CIDR notation IP for Docker bridge
  }

  service_principal {
    client_id     = var.client_id
    client_secret = var.client_secret
  }

  tags = {
    environment = var.environment
  }

  lifecycle {
    ignore_changes = [
      service_principal[0].client_id,
      service_principal[0].client_secret,
    ]
  }
}

# Create Namespaces
resource "kubernetes_namespace" "aks_svl_namespace" {
  for_each            = var.aks_svl_namespaces
  metadata {
    annotations = {
      name            = each.key
    }
  labels = {
      environment     = var.environment
    }
    name = each.key
  }
  depends_on = [azurerm_kubernetes_cluster.aks]
}