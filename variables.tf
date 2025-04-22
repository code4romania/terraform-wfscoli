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
  default     = "eu-west-1"
}

variable "subdomain" {
  description = "Subdomain of wfscoli.ro used by the application. Will create Route 53 zone."
  type        = string
}

variable "bastion_public_key" {
  description = "Public SSH key used to connect to the bastion"
  type        = string
}

variable "create_iam_service_linked_role" {
  description = "Whether to create `AWSServiceRoleForECS` service-linked role. Set it to `false` if you already have an ECS cluster created in the AWS account and AWSServiceRoleForECS already exists."
  type        = bool
  default     = true
}

variable "enable_execute_command" {
  description = "Enable aws ecs execute_command"
  type        = bool
  default     = false
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
