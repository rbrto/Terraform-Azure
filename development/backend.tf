terraform {
  backend "azurerm" {
    storage_account_name = "terraformsvldev"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
  }
}