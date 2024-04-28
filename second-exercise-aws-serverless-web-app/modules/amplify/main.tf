terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.32.0"
    }
  }

  required_version = ">= 1.2.0"
}

resource "aws_amplify_app" "web_app" {
  name = "${var.amplify_name_prefix}Tf"
  repository = var.git_repo_name
  access_token = var.git_access_token
  enable_branch_auto_build = var.amplify_enable_branch_auto_build
  enable_auto_branch_creation = var.amplify_enable_branch_auto_creation
  auto_branch_creation_patterns = var.amplify_branch_auto_creation_pattern
  environment_variables = {
    ENV = var.amplify_env,
    API_GW_ADDRESS = var.amplify_api_gw_address
  }
  tags = var.amplify_tags
  depends_on = [var.amplify_api_gw_address]
}