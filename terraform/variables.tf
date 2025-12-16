variable "prefix" {
  description = "The prefix used for all resources"
  type        = string
  default     = "GopalProject"
}

variable "environment" {
  description = "The deployment environment (dev, qa, prod)"
  type        = string
  default     = "dev" 
}

variable "location" {
  description = "The Azure Region"
  type        = string
  default     = "North Central US"
}

variable "sql_admin_username" {
  description = "Database Administrator username"
  type        = string
  default     = "adminuser"
}

variable "sql_admin_password" {
  description = "Database Administrator password"
  type        = string
  sensitive   = true
  default     = "ComplexPassword123!" 
}