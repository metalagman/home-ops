locals {
  # Automatically load environment-level variables
  env_vars = yamldecode(file(find_in_parent_folders("env.yaml")))

  # Extract the variables we need for easy access
  aws_region = get_env("AWS_REGION")

  s3_state_bucket = get_env("S3_STATE_BUCKET")
  s3_state_assume_role = get_env("S3_STATE_ASSUME_ROLE")

  basename = local.env_vars.basename
}

# Generate an AWS provider block
generate "provider_aws" {
  path      = "provider_aws.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "aws" {
  region = "${local.aws_region}"
}
EOF
}

# Configure Terragrunt to automatically store tfstate files in an S3 bucket
remote_state {
  backend = "s3"
  config = {
    encrypt      = true
    bucket = local.s3_state_bucket
    assume_role = {
      role_arn = local.s3_state_assume_role
    }
    key          = "terraform/${path_relative_to_include()}/tf.tfstate"
    region       = "eu-central-1"
    use_lockfile = true
  }
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# GLOBAL PARAMETERS
# These variables apply to all configurations in this subfolder. These are automatically merged into the child
# `terragrunt.hcl` config via the include block.
# ---------------------------------------------------------------------------------------------------------------------

# Configure root level variables that all resources can inherit. This is especially helpful with multi-account configs
# where terraform_remote_state data sources are placed directly into the modules.
inputs = merge(
  local.env_vars,
)
