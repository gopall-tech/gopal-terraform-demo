variable "prefix" {
  description = " The prefix used for all resources in this example"
  type        = string
  default     = "Gopal"
}

variable "location" {
  description = "The Azure Region in which all resources in this example should be created."
  type        = string
  default     = "East US"
}

variable "sql_admin_username" {
  description = "Administrator username for the SQL Server"
  type        = string
  default     = "adminuser"
}

variable "sql_admin_password" {
  description = "Administrator password for the SQL Server"
  type        = string
  sensitive   = true
  default     = "ComplexPassword123!" 
}