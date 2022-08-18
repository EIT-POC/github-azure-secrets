locals {
  filtered = {
    for k, v in data.azurerm_key_vault_secret.this : k => v
    if length(regexall(var.name_filter, join(",", [for tk, tv in v.tags : "${tk}=${tv}"]))) > 0
  }
}
# Create secrets at the Repository level
resource "github_actions_secret" "this" {
  for_each = {
    for k, v in local.filtered : k => v
    if var.scope_to_repository
  }
  repository      = data.github_repository.this[0].name
  secret_name     = replace(each.key, "-", "_")
  plaintext_value = each.value.value
}
# Create secrets at the Organization level
resource "github_actions_organization_secret" "this" {
  for_each = {
    for k, v in local.filtered : k => v
    if !var.scope_to_repository
  }
  secret_name     = replace(each.key, "-", "_")
  visibility      = "private"
  plaintext_value = each.value.value
}
