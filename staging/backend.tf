terraform {
  backend "azurerm" {
    storage_account_name = "terraformsvlstaging"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
  }
}

