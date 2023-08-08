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

# Create an Azure Stream Analytics job to copy events from the East US Event Hub to the West US Event Hub
resource "azurerm_stream_analytics_job" "copy_eastus_to_westus" {
  name                = "copy-eastus-to-westus"
  location            = azurerm_resource_group.eastus.location
  resource_group_name = azurerm_resource_group.eastus.name
  sku                 = "Standard"
  eventsink {
    id   = azurerm_eventhub.westus.id
    type = "EventHub"
  }
  inputs {
    name                 = "eastus-input"
    datasource {
      type                 = "EventHub"
      eventhub_name        = azurerm_eventhub.eastus.name
      service_bus_namespace = azurerm_eventhub_namespace.eastus.name
      shared_access_policy_name = "RootManageSharedAccessKey"
      shared_access_policy_key  = azurerm_eventhub_namespace.eastus.default_primary_connection_string
      consumer_group            = "$Default"
    }
    serialization {
      type = "JSON"
    }
  }
  outputs {
    name = "westus-output"
  }
}

# Create a query for the job 
resource "azurerm_stream_analytics_job_query" "copy_eastus_to_westus" {
  job_name         = azurerm_stream_analytics_job.copy_eastus_to_westus.name
  query            = "SELECT * INTO westus-output FROM eastus-input"
  output_name      = "westus-output"
  output_datasource_type = "EventHub"
  output_eventhub_name = azurerm_eventhub.westus.name
  output_service_bus_namespace = azurerm_eventhub_namespace.westus.name
  output_shared_access_policy_name = "RootManageSharedAccessKey"
  output_shared_access_policy_key  = azurerm_eventhub_namespace.westus.default_primary_connection_string
}