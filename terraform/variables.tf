variable "prefix" {
  description = "A prefix used for all resources in this example"
  default     = "azte"
}

variable "location" {
  default     = "West Europe"
  description = "The Azure Region in which all resources in this example should be provisioned"
}


variable "client_id" {
  description = "The Azure Service Principal app ID."
}
variable "client_secret" {
  description = "The Azure Service Principal password."
}
variable "subscription_id" {
  description = "The Azure subscription ID."
}
variable "tenant_id" {
  description = "The Azure Tenant ID."
}
