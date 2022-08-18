# GitHub Azure Secrets

GitHub Azure Secrets is a Terraform module for syncing secrets from an Azure Key Vault into GitHub as either organization or repository secrets.

## Usage

To create organization level secrets:

```hcl
module "github-azure-secrets" {
  source = "git::https://github.com/EIT-POC/github-azure-secrets.git"

  arm_subscription_id = var.arm_subscription_id
  arm_tenant_id       = var.arm_tenant_id
  arm_client_id       = var.arm_client_id
  arm_client_secret   = var.arm_client_secret
  github_token        = var.github_token
  vault_name          = "my-vault"
  resource_group      = "my-resource-group"
  organization        = "my-org"
}
```

To create repository level secrets for a repository within an organization:

```hcl
module "github-azure-secrets" {
  source = "git::https://github.com/EIT-POC/github-azure-secrets.git"

  arm_subscription_id = var.arm_subscription_id
  arm_tenant_id       = var.arm_tenant_id
  arm_client_id       = var.arm_client_id
  arm_client_secret   = var.arm_client_secret
  scope_to_repository = true
  vault_name          = "my-vault"
  resource_group      = "my-resource-group"
  organization        = "my-org"
  repository          = "my-repo"
  repo_within_org     = true
}
```

To create repository level secrets for a personal repository:

```hcl
module "github-azure-secrets" {
  source = "git::https://github.com/EIT-POC/github-azure-secrets.git"

  arm_subscription_id = var.arm_subscription_id
  arm_tenant_id       = var.arm_tenant_id
  arm_client_id       = var.arm_client_id
  arm_client_secret   = var.arm_client_secret
  scope_to_repository = true
  vault_name          = "my-vault"
  resource_group      = "my-resource-group"
  organization        = "my-org"
  repository          = "my-repo"
  user                = "my-user"
}
```

With a private GitHub instance:

```hcl
module "github-azure-secrets" {
  source = "git::https://github.com/EIT-POC/github-azure-secrets.git"

  arm_subscription_id = var.arm_subscription_id
  arm_tenant_id       = var.arm_tenant_id
  arm_client_id       = var.arm_client_id
  arm_client_secret   = var.arm_client_secret
  scope_to_repository = true
  vault_name          = "my-vault"
  resource_group      = "my-resource-group"
  organization        = "my-org"
  repository          = "my-repo"
  repo_within_org     = true
  base_url            = "https://api.my-personal-github.com/"
}
```

Using filters:

```hcl
module "github-azure-secrets" {
  source = "git::https://github.com/EIT-POC/github-azure-secrets.git"

  arm_subscription_id = var.arm_subscription_id
  arm_tenant_id       = var.arm_tenant_id
  arm_client_id       = var.arm_client_id
  arm_client_secret   = var.arm_client_secret
  scope_to_repository = true
  vault_name          = "my-vault"
  resource_group      = "my-resource-group"
  organization        = "my-org"
  repository          = "my-repo"
  repo_within_org     = true
  base_url            = "https://api.my-personal-github.com/"
  name_filter         = ".*"
  tag_filter          = "app=myapp"
}
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| azurerm | ~> 3.0 |
| github | ~> 4.0 |

## Providers

| Name | Version |
|------|---------|
| azurerm | ~> 3.0 |
| github | ~> 4.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [github_actions_organization_secret.this](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/actions_organization_secret) | resource |
| [github_actions_secret.this](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/actions_secret) | resource |
| [azurerm_key_vault.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault) | data source |
| [azurerm_key_vault_secret.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault_secret) | data source |
| [azurerm_key_vault_secrets.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault_secrets) | data source |
| [github_organization.this](https://registry.terraform.io/providers/integrations/github/latest/docs/data-sources/organization) | data source |
| [github_repository.this](https://registry.terraform.io/providers/integrations/github/latest/docs/data-sources/repository) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| arm\_client\_id | Azure Client ID to use for authentication. | `string` | n/a | yes |
| arm\_client\_secret | Azure Client Secret to use for authentication. | `string` | n/a | yes |
| arm\_subscription\_id | Azure subscription ID | `string` | n/a | yes |
| arm\_tenant\_id | Azure Tenant ID | `string` | n/a | yes |
| base\_url | (Optional) This is the target GitHub base API endpoint. Providing a value is a requirement when working with GitHub Enterprise. | `string` | `"https://api.github.com/"` | no |
| github\_token | The GitHub token to use for authentication. | `string` | n/a | yes |
| name\_filter | (Optional) A regex filter to limit the secrets that are synced by name. | `string` | `".*"` | no |
| organization | (Optional) The case-sensitive name of the organization that we will be syncing secrets to. If repo\_within\_org is true, the organization and repo will be combined with a '/'. | `string` | `"some-org"` | no |
| read\_delay\_ms | (Optional) The number of milliseconds to sleep in between non-write operations in order to satisfy the GitHub API rate limits. Defaults to 0ms | `number` | `0` | no |
| repo\_within\_org | (Optional) If true and scope\_to\_repository true, the repository will be looked for within var.organization. Defaults to false. | `bool` | `false` | no |
| repository | (Optional) If scope\_to\_repository is true, this is the name of the repository to scope the secrets to. | `string` | `"some-repo"` | no |
| resource\_group | The Resource Group that the Key Vault resides in | `string` | n/a | yes |
| scope\_to\_repository | (Optional) If true, secrets will be scoped to an indivual repository, else secrets will be created at the organization level. Defaults to false. | `bool` | `false` | no |
| tag\_filter | (Optional) A regex filter to limit the secrets that are synced by tags. | `string` | `".*"` | no |
| user | (Optional) If scope\_to\_repository is true, this is the owner of the GitHub repository that we will be syncing secrets to. | `string` | `"some-user"` | no |
| vault\_name | The name of the Azure Key Vault that we will crawl for secrets | `string` | n/a | yes |
| write\_delay\_ms | (Optional) The number of milliseconds to sleep in between write operations in order to satisfy the GitHub API rate limits. Defaults to 1000ms. | `number` | `1000` | no |

## Outputs

| Name | Description |
|------|-------------|
| destination | Information about the destination of the secrets. kind: repository or organization, name: name of the repository or organization, secrets: list of secret names managed by this module |
| source | Information about the source of the secrets. kind: keyVault, name: name of the key vault, secrets: map of secret names to version hashes |
<!-- END_TF_DOCS -->

## Updating Documentation

This module uses [terraform-docs](https://github.com/terraform-docs/terraform-docs) to generate the documentation.

Usage:

```shell
terraform-docs markdown table --html=false --anchor=false --output-file README.md --output-mode inject .
```
