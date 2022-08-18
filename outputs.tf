locals {
  vault_id = split("/", data.azurerm_key_vault_secrets.this.id)
}
output "source" {
  description = "Information about the source of the secrets. kind: keyVault, name: name of the key vault, secrets: map of secret names to version hashes"
  value = {
    kind    = "keyVault"
    name    = element(local.vault_id, length(local.vault_id) - 1)
    secrets = { for k, v in data.azurerm_key_vault_secret.this : k => v.version }
  }
}
output "destination" {
  description = "Information about the destination of the secrets. kind: repository or organization, name: name of the repository or organization, secrets: list of secret names managed by this module"
  value = {
    kind    = var.scope_to_repository ? "repository" : "organization"
    name    = var.scope_to_repository ? data.github_repository.this[0].full_name : data.github_organization.this.orgname
    secrets = [for k, v in data.azurerm_key_vault_secret.this : replace(k, "-", "_")]
  }
}
