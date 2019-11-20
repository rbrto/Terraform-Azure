# Create Azure Redis
resource "azurerm_redis_cache" "redis" {
  name                = "${var.project_name}-${var.environment}-redis"
  location            = var.location
  resource_group_name = var.resource_group
  capacity            = var.capacity
  family              = var.family
  sku_name            = var.sku_name
  enable_non_ssl_port = var.enable_non_ssl_port

  tags = {
    environment = var.environment
  }
}