# ##############################################
# ## Generic
# ##############################################

# Set Resource Group
variable "resource_group" {
  default = "svl-staging-rg"
}

# Set Project Name
variable "project_name" {
  default = "svl"
}

# Set Environment
variable "environment" {
  default = "staging"
}

# Set default location
variable "location" {
  default = "eastus"
}

# Set TenantID
variable tenant_id {}

# Set ObjectID
variable object_id {}

# Set Container Registry SKU
variable "container_registry_sku" {
  default = "Standard"
}

# Set Admin User
variable "admin_enabled" {
  default = "true"
}

# ##########################
# ## Networking
# ##########################

# Set Vnet Address Space
variable "address_space" {
  default = ["10.100.0.0/16"]
}

# Set Subnet Address Prefix
variable "address_prefix" {
  default = "10.100.0.0/20"
}

# Set Subnet Service Endpoints
variable "service_endpoints" {
  default = [
    "Microsoft.Sql",
    "Microsoft.AzureCosmosDB",
    "Microsoft.KeyVault"
  ]
}

# Set Network Security Rules
variable "security_rules" {
  type = list(object({
    name                       = string
    priority                   = number
    direction                  = string
    access                     = string
    protocol                   = string
    source_port_range          = string
    destination_port_range     = string
    source_address_prefix      = string
    destination_address_prefix = string
  }))
  default = [
    {
      name                       = "HTTPS"
      priority                   = 1001
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "443"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    },
    {
      name                       = "HTTP"
      priority                   = 1002
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "80"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    }
  ]
}

# ##########################
# ## AKS
# ##########################

# Set ClientID
variable "client_id" {}

# Set Client Secret
variable "client_secret" {}

# Set Agent Pools
variable "agent_pools" {
  type = list(object({
    name            = string
    count           = number
    vm_size         = string
    os_type         = string
    os_disk_size_gb = number
  }))
  default = [
    {
      name            = "pool1"
      count           = 5
      vm_size         = "Standard_D4_v3"
      os_type         = "Linux"
      os_disk_size_gb = 30
    }
  ]
}

# Set Network Profile
variable "network_profile" {
  type = object({
    network_plugin     = string
    service_cidr       = string
    dns_service_ip     = string
    docker_bridge_cidr = string
  })
  default = {
    network_plugin     = "azure"
    service_cidr       = "10.2.0.0/20"
    dns_service_ip     = "10.2.0.10"
    docker_bridge_cidr = "172.17.0.1/16"
  }
}

# Set AKS version
variable "aks_kubernetes_version" {
  default = "1.13.12"
}

# Set AKS namespaces
variable "aks_svl_namespaces" {
  type        = set(string)
  default     = [] # ["price", "stock", "products"]
  description = "Namespaces to be created after cluster creation"
}

# ##############################################
# ## Database
# ##############################################

# Set username sql server instance
variable "db_username" {}

# Set password sql server instance
variable "db_password" {}


# ##########################
# ## Redis
# ##########################

variable "capacity" {
  default = "2"
}

variable "family" {
  default = "C"
}

variable "sku_name" {
  default = "Standard"
}

variable "enable_non_ssl_port" {
  default = "true"
}

# ##############################################
# ## Tiller
# ##############################################

variable "tiller_namespace" {
  type        = string
  default     = "kube-system"
  description = "The Kubernetes namespace to use to deploy Tiller."
}

variable "tiller_service_account" {
  type        = string
  default     = "tiller"
  description = "The Kubernetes service account to add to Tiller."
}

variable "tiller_replicas" {
  description = "The amount of Tiller instances to run on the cluster."
  default     = 1
}

variable "tiller_image" {
  type        = string
  default     = "gcr.io/kubernetes-helm/tiller"
  description = "The image used to install Tiller."
}

variable "tiller_version" {
  type        = string
  default     = "v2.15.2"
  description = "The Tiller image version to install."
}

variable "tiller_max_history" {
  default     = 0
  description = "Limit the maximum number of revisions saved per release. Use 0 for no limit."
}

variable "tiller_net_host" {
  type        = string
  default     = true
  description = "Install Tiller with net=host."
}

variable "tiller_node_selector" {
  type        = map(string)
  default     = {}
  description = "Determine which nodes Tiller can land on."
}
