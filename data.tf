locals {
  # If secrets are scoped to an organization, we will validate the existence of the organization
  # by relying on the organization data source output for the name, rather than raw user input.
  name         = var.repo_within_org ? "${data.github_organization.this.orgname}/${var.repository}" : "${var.user}/${var.repository}"
  secret_names = [for i in data.azurerm_key_vault_secrets.this.names : i if length(regexall(var.name_filter, i)) > 0]
}
data "azurerm_key_vault" "this" {
  name                = var.vault_name
  resource_group_name = var.resource_group
}
data "azurerm_key_vault_secrets" "this" {
  key_vault_id = data.azurerm_key_vault.this.id
}
# Create set of datasources with one object for each secret in the vault
data "azurerm_key_vault_secret" "this" {
  for_each     = toset(local.secret_names)
  name         = each.key
  key_vault_id = data.azurerm_key_vault.this.id
}
# Conditional data source for repository, if the secret destination is a repository
data "github_repository" "this" {
  count     = var.scope_to_repository ? 1 : 0
  full_name = local.name
}
# Data source for GitHub organization
data "github_organization" "this" {
  name = var.organization
}
