terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
    github = {
      source  = "integrations/github"
      version = "~> 4.0"
    }
  }
}
# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
}
# Configure the GitHub Provider
provider "github" {
  owner          = var.scope_to_repository ? var.repo_within_org ? var.organization : var.user : var.organization
  token          = var.GITHUB_TOKEN
  base_url       = var.base_url
  write_delay_ms = var.write_delay_ms
  read_delay_ms  = var.read_delay_ms
}
