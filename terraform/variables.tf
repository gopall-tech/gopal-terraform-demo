variable "prefix" {
  description = "Prefix for resources (naming convention)."
  type        = string
  default     = "gopalcloud"
}

variable "location" {
  description = "Azure region."
  type        = string
  default     = "westus2"
}

variable "environments" {
  description = "Environments to deploy."
  type        = set(string)
  default     = ["dev", "qa", "prod"]
}

variable "tags" {
  description = "Common tags."
  type        = map(string)
  default = {
    project = "gopal-capstone"
  }
}

variable "postgres_admin_user" {
  description = "PostgreSQL admin user."
  type        = string
  default     = "gopaladmin"
}

variable "postgres_admin_password" {
  description = "PostgreSQL admin password."
  type        = string
  sensitive   = true
}

variable "apim_sku_name" {
  description = "APIM SKU (cheaper: Consumption_0)."
  type        = string
  default     = "Consumption_0"
}

variable "apim_publisher_name" {
  description = "APIM publisher name."
  type        = string
  default     = "Gopal Corp"
}

variable "apim_publisher_email" {
  description = "APIM publisher email."
  type        = string
  default     = "gopal@example.com"
}

variable "ui_plan_sku_name" {
  description = "App Service plan SKU (cheap & reliable: B1)."
  type        = string
  default     = "B1"
}

# --- ADDED MISSING VARIABLES BELOW ---

variable "aks_node_count" {
  description = "Number of worker nodes for the AKS cluster."
  type        = number
  default     = 1
}

variable "aks_vm_size" {
  description = "VM size for the AKS nodes."
  type        = string
  default     = "Standard_B2s"
}