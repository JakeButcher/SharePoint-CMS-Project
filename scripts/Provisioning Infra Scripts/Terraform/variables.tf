variable "resource_group_name" {
  description = "SharePoint-CMS-Proj"
  type        = string
}

variable "location" {
  description = "Azure Region"
  type        = string
  default     = "West Europe"
}

variable "admin_username" {
  description = "Example"
  type        = string
}

variable "admin_password" {
  description = "Example"
  type        = string
  sensitive   = true
}