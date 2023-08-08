provider "azurerm" {
  features {}
}

# Resource Group for the East US Event Hub
resource "azurerm_resource_group" "eastus" {
  name     = "eventhub-eastus-rg"
  location = var.eastus_location
}

# Resource Group for the West US Event Hub
resource "azurerm_resource_group" "westus" {
  name     = "eventhub-westus-rg"
  location = var.westus_location
}

# Event Hub Namespace in East US
resource "azurerm_eventhub_namespace" "eastus" {
  name                = "eventhub-namespace-eastus"
  location            = azurerm_resource_group.eastus.location
  resource_group_name = azurerm_resource_group.eastus.name
  sku                 = var.sku
  capacity            = var.capacity
}

# Event Hub in East US
resource "azurerm_eventhub" "eastus" {
  name                = "eventhub-eastus"
  namespace_name      = azurerm_eventhub_namespace.eastus.name
  resource_group_name = azurerm_resource_group.eastus.name
  partition_count     = var.partition_count
  message_retention   = var.message_retention
}

# Event Hub Namespace in West US
resource "azurerm_eventhub_namespace" "westus" {
  name                = "eventhub-namespace-westus"
  location            = azurerm_resource_group.westus.location
  resource_group_name = azurerm_resource_group.westus.name
  sku                 = var.sku
  capacity            = var.capacity
}

# Event Hub in West US
resource "azurerm_eventhub" "westus" {
  name                = "eventhub-westus"
  namespace_name      = azurerm_eventhub_namespace.westus.name
  resource_group_name = azurerm_resource_group.westus.name
  partition_count     = var.partition_count
  message_retention   = var.message_retention
}
