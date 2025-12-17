variable "prefix" {
  description = "The prefix for all resources"
  # CHANGED: New name to bypass the "Already Exists" error
  default     = "GopalCloud" 
}

variable "location" {
  description = "The Azure Region"
  default     = "West US 2"
}

variable "environments" {
  description = "The environments to deploy"
  type        = set(string)
  # CHANGED: Deploy only "dev" to fit inside Azure Student Quota
  default     = ["dev"] 
}