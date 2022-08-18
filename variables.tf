# Required Env Vars:
# - ARM_SUBSCRIPTION_ID
# - ARM_TENANT_ID
# - ARM_CLIENT_ID
# - ARM_CLIENT_SECRET
# - TF_VAR_GITHUB_TOKEN

# ^[a-zA-Z0-9-]{3,24}$
# https://docs.microsoft.com/en-us/rest/api/keyvault/keyvault/vaults/create-or-update?tabs=HTTP
variable "vault_name" {
  type        = string
  description = "The name of the Azure Key Vault that we will crawl for secrets"
  validation {
    condition     = can(regex("^[a-zA-Z0-9-]{3,24}$", var.vault_name))
    error_message = "Valid vault names are 3-24 characters in length, begin with an alphanumeric character and may contain dashes."
  }
}

# ^[-\w\._\(\)]+$
# Note: '\' must be escaped in HCL. For example '\w' should be written as '\\w' in HCL.
# https://docs.microsoft.com/en-us/rest/api/resources/resource-groups/create-or-update?tabs=HTTP
variable "resource_group" {
  type        = string
  description = "The Resource Group that the Key Vault resides in"
  validation {
    condition     = can(regex("^[-\\w\\._\\(\\)]+$", var.resource_group))
    error_message = "Valid resource group names may include alphanumeric, underscore, parentheses, hyphen, period (except at end), and Unicode characters that match the allowed characters."
  }
}

variable "scope_to_repository" {
  type        = bool
  default     = false
  description = "(Optional) If true, secrets will be scoped to an indivual repository, else secrets will be created at the organization level. Defaults to false."
}

variable "repo_within_org" {
  type        = bool
  default     = false
  description = "(Optional) If true and scope_to_repository true, the repository will be looked for within var.organization. Defaults to false."
}

variable "repository" {
  type        = string
  default     = "some-repo"
  description = "(Optional) If scope_to_repository is true, this is the name of the repository to scope the secrets to."
  validation {
    condition     = can(regex("^[a-zA-Z0-9-_.]{1,101}$", var.repository))
    error_message = "Valid repository names must be 1-101 characters in length and may include alphanumeric characters, underscore, hyphen, and period."
  }
}

variable "organization" {
  type        = string
  default     = "some-org"
  description = "(Optional) The case-sensitive name of the organization that we will be syncing secrets to. If repo_within_org is true, the organization and repo will be combined with a '/'."
  validation {
    condition     = can(regex("^(?:(?:[a-zA-Z0-9]+[a-zA-Z0-9-.])+[a-zA-Z0-9]){1,39}$", var.organization))
    error_message = "Valid organization names must be 1-101 characters in length and may include alphanumeric characters, underscore, hyphen, and period."
  }
}

variable "user" {
  type        = string
  default     = "some-user"
  description = "(Optional) If scope_to_repository is true, this is the owner of the GitHub repository that we will be syncing secrets to."
  validation {
    condition     = can(regex("^[A-Za-z0-9](?:[-]|[A-Za-z0-9]){3,38}$", var.user))
    error_message = "Valid user names must be 1-39 characters in length and may include alphanumeric characters and hyphens."
  }
}

variable "write_delay_ms" {
  type        = number
  default     = 1000
  description = "(Optional) The number of milliseconds to sleep in between write operations in order to satisfy the GitHub API rate limits. Defaults to 1000ms."
}

variable "read_delay_ms" {
  type        = number
  default     = 0
  description = "(Optional) The number of milliseconds to sleep in between non-write operations in order to satisfy the GitHub API rate limits. Defaults to 0ms"
}

variable "base_url" {
  type        = string
  default     = "https://api.github.com/"
  description = "(Optional) This is the target GitHub base API endpoint. Providing a value is a requirement when working with GitHub Enterprise."
  validation {
    condition     = can(regex("^(?:https?):[/]{2}[-A-Za-z0-9+&@#/%?=~_|!:,.;]+[-A-Za-z0-9+&@#/%=~_|][/]{1}$", var.base_url))
    error_message = "Valid base URL must begin with 'http://' or 'https://', contain valid characters and end with '/'."
  }
}

# https://github.com/integrations/terraform-provider-github/issues/578
# integrations/github < v5 discards owner if using GITHUB_TOKEN from env
# workaround is to pass the token as a variable.  
variable "GITHUB_TOKEN" {
  type        = string
  description = "The GitHub token to use for authentication."
  sensitive   = true
}

variable "tag_filter" {
  type        = string
  default     = ".*"
  description = "(Optional) A regex filter to limit the secrets that are synced by tags."
}

variable "name_filter" {
  type        = string
  default     = ".*"
  description = "(Optional) A regex filter to limit the secrets that are synced by name."
}
