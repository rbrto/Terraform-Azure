# Create Sql Server Instance
resource "azurerm_sql_server" "sqlserver" {
  name                         = "${var.name}-${var.environment}-sql" # unique global name
  resource_group_name          = var.resource_group_name
  location                     = var.location
  version                      = "12.0"
  administrator_login          = var.secret_username
  administrator_login_password = var.secret_password
  tags = {
     environment = var.environment
  }
}

# Allow Access to Azure Resources
resource "azurerm_sql_firewall_rule" "allow_all_azure_ips" {
  name                = "AllowAllAzureIps"
  resource_group_name = var.resource_group_name
  server_name         = azurerm_sql_server.sqlserver.name
  start_ip_address    = "0.0.0.0"
  end_ip_address      = "0.0.0.0"
}

# Allow Access Subnet with Service Endpoints
resource "azurerm_sql_virtual_network_rule" "sqlvnetrule" {
  name                = "sql-vnet-rule"
  resource_group_name = var.resource_group_name
  server_name         = azurerm_sql_server.sqlserver.name
  subnet_id           = var.aks_subnet_id
}

# Create Databases
resource "azurerm_sql_database" "database" {
  count                = length(var.databases)
  name                 = element(var.databases, count.index)
  resource_group_name  = var.resource_group_name
  location             = var.location
  server_name          = azurerm_sql_server.sqlserver.name
  edition              = "Standard"
  requested_service_objective_name = "S1"

  tags = {
     environment = var.environment
  }
}