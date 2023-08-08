output "eastus_eventhub_connection_string" {
  description = "Connection string for the East US Event Hub"
  value       = azurerm_eventhub_namespace.eastus.default_primary_connection_string
}

output "westus_eventhub_connection_string" {
  description = "Connection string for the West US Event Hub"
  value       = azurerm_eventhub_namespace.westus.default_primary_connection_string
}