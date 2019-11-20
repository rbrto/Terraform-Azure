
# Create Virtual Network (VNet)
resource "azurerm_virtual_network" "aks" {
  name                = "${var.project_name}-vnet"
  address_space       = var.address_space
  location            = var.location
  resource_group_name = var.resource_group

  tags = {
    environment = var.environment
  }
}

# Create Network Security Group
resource "azurerm_network_security_group" "nsg" {
  name                = "${var.project_name}-nsg"
  location            = var.location
  resource_group_name = var.resource_group

  dynamic "security_rule" {
    for_each = var.security_rules
    iterator = pool
    content {
      name                       = pool.value.name
      priority                   = pool.value.priority
      direction                  = pool.value.direction
      access                     = pool.value.access
      protocol                   = pool.value.protocol
      source_port_range          = pool.value.source_port_range
      destination_port_range     = pool.value.destination_port_range
      source_address_prefix      = pool.value.source_address_prefix
      destination_address_prefix = pool.value.destination_address_prefix
    }
  }

  tags = {
    environment = var.environment
  }
}

# Create AKS Subnet 
resource "azurerm_subnet" "aks" {
  name                      = "${var.project_name}-subnet"
  resource_group_name       = var.resource_group
  virtual_network_name      = azurerm_virtual_network.aks.name
  network_security_group_id = azurerm_network_security_group.nsg.id
  address_prefix            = var.address_prefix

  # List of Service endpoints to associate with the subnet.
  service_endpoints = var.service_endpoints
}