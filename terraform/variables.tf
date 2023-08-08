variable "eastus_location" {
  description = "Azure region for the East US Event Hub"
  type        = string
  default     = "East US"
}

variable "westus_location" {
  description = "Azure region for the West US Event Hub"
  type        = string
  default     = "West US"
}

variable "sku" {
  description = "The SKU of the Event Hub Namespace. E.g., Basic, Standard"
  type        = string
  default     = "Standard"
}

variable "capacity" {
  description = "The capacity of the SKU, typically 1 for the Standard SKU"
  type        = number
  default     = 1
}

variable "partition_count" {
  description = "The number of partitions in the Event Hub"
  type        = number
  default     = 4
}

variable "message_retention" {
  description = "The number of days to retain the events for in the Event Hub"
  type        = number
  default     = 1
}