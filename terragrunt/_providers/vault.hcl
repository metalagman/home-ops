locals {
  vault_server = get_env("VAULT_SERVER")
  vault_token = get_env("VAULT_TOKEN")
}


# Generate an Vault provider block
generate "provider_vault" {
  path      = "provider_vault.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "vault" {
  address = "${local.vault_server}"
  token   = "${local.vault_token}"
}
EOF
}
