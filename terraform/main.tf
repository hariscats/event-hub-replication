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

# Stream Analytics Job input from East US Event Hub
resource "azurerm_stream_analytics_stream_input_eventhub" "eastus" {
  name                = "eastus-input"
  stream_analytics_job_name = azurerm_stream_analytics_job.stream_analytics_job.name
  resource_group_name = azurerm_resource_group.eastus.name
  servicebus_namespace = azurerm_eventhub_namespace.eastus.name
  eventhub_name       = azurerm_eventhub.eastus.name
  consumer_group      = "$Default"
}

# Stream Analytics Job output to West US Event Hub
resource "azurerm_stream_analytics_output_eventhub" "westus" { 
  name                = "westus-output"
  stream_analytics_job_name = azurerm_stream_analytics_job.stream_analytics_job.name
  resource_group_name = azurerm_resource_group.westus.name
  servicebus_namespace = azurerm_eventhub_namespace.westus.name
  eventhub_name       = azurerm_eventhub.westus.name
  partition_key       = "PartitionId"
}

# Stream Analytics Job to process data from East US Event Hub and output to West US Event Hub
resource "azurerm_stream_analytics_job" "stream_analytics_job" {
  name                = "stream-analytics-job"
  location            = azurerm_resource_group.eastus.location
  resource_group_name = azurerm_resource_group.eastus.name
  transformation_query =  <<QUERY
    SELECT
        *
    INTO
        westus
    FROM
        eastus TIMESTAMP BY EventEnqueuedUtcTime 
  QUERY
}