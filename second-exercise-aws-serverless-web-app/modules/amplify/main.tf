terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.32.0"
    }
  }

  required_version = ">= 1.2.0"
}

############################################
#              Amplify App                 #
############################################

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
  tags = merge(var.tags, {
    DeployTime = timestamp()
  })
  depends_on = [var.amplify_api_gw_address]
}

############################################
#     Adding GH Branch to Amplify App      #
############################################

resource "aws_amplify_branch" "web_app" {
  app_id      = aws_amplify_app.web_app.id
  branch_name = "main"
  tags = merge(var.tags, {
    DeployTime = timestamp()
  })
}