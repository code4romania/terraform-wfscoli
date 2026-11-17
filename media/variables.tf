variable "env" {
  description = "Environment"
  type        = string

  validation {
    condition     = contains(["production", "staging"], var.env)
    error_message = "Allowed values for env are \"production\" or \"staging\"."
  }
}

variable "region" {
  description = "Region"
  type        = string
  default     = "eu-central-1"
}

variable "subdomain" {
  description = "Subdomain of wfscoli.ro used by the application. Will create Route 53 zone."
  type        = string
}

variable "ses_region" {
  description = "SES Region"
  type        = string
  default     = null
}

variable "ses_domain" {
  description = "Domain for AWS SES"
  type        = string
  default     = null
}

variable "ses_configuration_set" {
  description = "Configuration set name attached to `ses_domain`"
  type        = string
  default     = null
}
