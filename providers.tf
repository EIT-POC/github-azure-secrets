terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
    github = {
      source  = "integrations/github"
      version = "~> 5.6"
    }
  }
}
# Configure the Microsoft Azure Provider
provider "azurerm" {
  tenant_id       = var.arm_tenant_id
  client_id       = var.arm_client_id
  client_secret   = var.arm_client_secret
  subscription_id = var.arm_subscription_id

  features {}
}
# Configure the GitHub Provider
provider "github" {
  owner          = var.scope_to_repository ? var.repo_within_org ? var.organization : var.user : var.organization
  token          = var.github_token
  base_url       = var.base_url
  write_delay_ms = var.write_delay_ms
  read_delay_ms  = var.read_delay_ms
}
