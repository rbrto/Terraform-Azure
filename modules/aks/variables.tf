##############################################
## Generic
##############################################

variable "location" {}

variable "environment" {}

variable "resource_group_name" {}

variable "client_id" {}

variable "client_secret" {}

variable "name" {}

##############################################
## AKS
##############################################

variable "aks_kubernetes_version" {}

variable "aks_subnet_id" {}

variable "aks_svl_namespaces" {}

variable "network_profile" {
  type = object({
    network_plugin      = string
    service_cidr        = string
    dns_service_ip      = string
    docker_bridge_cidr  = string
  })
}

variable "agent_pools" {
  type = list(object({
    name                = string
    count               = number
    vm_size             = string
    os_type             = string
    os_disk_size_gb     = number
  }))
}