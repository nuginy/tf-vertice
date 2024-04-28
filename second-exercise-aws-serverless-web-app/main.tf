terraform {
  cloud {
    organization = "tf_vertice_mz"
    workspaces {
      name = "terraform-aws-serverless-app"
    }
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.32.0"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region = var.aws_region
}

module "dynamo_db" {
  source = "./modules/dynamodb"
  providers = {
    aws = aws
  }
}

module "apigw_lambda" {
  source = "./modules/apigw_lambda"
  providers = {
    aws = aws
  }
  dynamodb_arn = module.dynamo_db.dynamodb_arn
}

module "amplify" {
  source = "./modules/amplify"
  providers = {
    aws = aws
  }
  amplify_api_gw_address = module.apigw_lambda.api_gw_invoke_url
  git_access_token = var.git_access_token
}
