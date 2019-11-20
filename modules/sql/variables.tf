
variable "location" {}

variable "environment" {}

variable "name" {}

variable "resource_group_name" {}

variable "aks_subnet_id" {}

variable "databases" {
  description = "Create database names"
  type = list(string)
  default     = ["neo", "trinity"]
}

variable "secret_username" {}

variable "secret_password" {}