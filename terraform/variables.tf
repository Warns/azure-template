variable "prefix" {
  type = string
  default     = "sociallme-k8s"
}

variable "location" {
  type = string
  default     = "westeurope"
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
