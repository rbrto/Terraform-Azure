# Generate random ID for names of resources that need to be unique
resource "random_id" "aks" {
  byte_length = 4
}

# Azure Key Vault
resource "azurerm_key_vault" "test" {
  name                = "${var.project_name}-${var.environment}-key-vault"
  location            = var.location
  resource_group_name = var.resource_group
  tenant_id           = var.tenant_id

  sku_name = "standard"

  enabled_for_deployment = true

  access_policy {
    tenant_id = var.tenant_id
    object_id = var.object_id

    key_permissions = [
      "get",
      "list",
      "create",
      "delete",
      "update",
    ]

    secret_permissions = [
      "get",
      "list",
      "delete",
      "set",
    ]

    certificate_permissions = [
      "get",
      "list",
      "create",
      "delete",
      "update",
    ]
  }

  tags = {
    environment = var.environment
  }

  lifecycle {
    ignore_changes = [
      access_policy[0].object_id
    ]
  }
}

resource "azurerm_key_vault_secret" "username" {
  name         = "secret-username"
  value        = var.db_username
  key_vault_id = azurerm_key_vault.test.id

  tags = {
    environment = var.environment
  }
}

resource "azurerm_key_vault_secret" "password" {
  name         = "secret-password"
  value        = var.db_password
  key_vault_id = azurerm_key_vault.test.id

  tags = {
    environment = var.environment
  }
}

resource "azurerm_container_registry" "container_registry" {
  name                = "${var.project_name}${var.environment}"
  resource_group_name = var.resource_group
  location            = var.location
  sku                 = var.container_registry_sku
  admin_enabled       = var.admin_enabled

  tags = {
    environment = var.environment
  }
}

# Create Azure Cosmos DB
# resource "azurerm_cosmosdb_account" "cosmosdb" {
#   name                = "cosmosdb-${random_id.aks.hex}"
#   location            = var.location
#   resource_group_name = var.resource_group
#   offer_type          = "Standard"
#   kind                = "GlobalDocumentDB"
#   consistency_policy {
#     consistency_level       = "BoundedStaleness"
#     max_interval_in_seconds = 10
#     max_staleness_prefix    = 200
#   }
#   geo_location {
#     prefix            = "${var.project_name}-customid"
#     location          = var.location
#     failover_priority = 0
#   }
#   tags = {
#      environment = "staging"
#   }
# }
