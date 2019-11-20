module "sql_stage" {
  source              = "../modules/sql"
  name                = var.project_name
  environment         = var.environment
  resource_group_name = var.resource_group
  location            = var.location
  aks_subnet_id       = azurerm_subnet.aks.id
  secret_username     = azurerm_key_vault_secret.username.value
  secret_password     = azurerm_key_vault_secret.password.value
}