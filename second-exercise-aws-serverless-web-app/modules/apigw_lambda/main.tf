terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.32.0"
    }
  }

  required_version = ">= 1.2.0"
}

module "cors" {
  source = "squidfunk/api-gateway-enable-cors/aws"
  version = "0.3.3"

  api_id          = aws_api_gateway_rest_api.web_app.id
  api_resource_id = aws_api_gateway_resource.root.id
  allow_methods = ["POST", "OPTIONS"]
}

resource "aws_api_gateway_rest_api" "web_app" {
  name = "${var.apigw_name_prefix}Tf"
  endpoint_configuration {
    types = var.apigw_endpoint_types
  }
}

resource "aws_api_gateway_resource" "root" {
  parent_id   = aws_api_gateway_rest_api.web_app.root_resource_id
  path_part   = var.apigw_root_path
  rest_api_id = aws_api_gateway_rest_api.web_app.id
  depends_on = [aws_api_gateway_rest_api.web_app]
}

resource "aws_api_gateway_method" "post" {
  authorization = var.apigw_method_auth
  http_method   = var.apigw_method_http_method
  resource_id   = aws_api_gateway_resource.root.id
  rest_api_id   = aws_api_gateway_rest_api.web_app.id
  depends_on = [aws_api_gateway_resource.root]
}

resource "aws_api_gateway_integration" "lambda" {
  http_method = aws_api_gateway_method.post.http_method
  resource_id = aws_api_gateway_resource.root.id
  rest_api_id = aws_api_gateway_rest_api.web_app.id
  type        = "AWS_PROXY"
  integration_http_method = var.apigw_method_http_method
  uri = aws_lambda_function.lambda_function.invoke_arn

  depends_on = [aws_api_gateway_resource.root, aws_lambda_function.lambda_function]
}

resource "aws_api_gateway_deployment" "web_app" {
  rest_api_id = aws_api_gateway_rest_api.web_app.id
  depends_on = [aws_api_gateway_method.post, aws_api_gateway_integration.lambda]
}

resource "aws_api_gateway_stage" "web_app" {
  deployment_id = aws_api_gateway_deployment.web_app.id
  rest_api_id   = aws_api_gateway_rest_api.web_app.id
  stage_name    = var.env
  depends_on = [aws_api_gateway_deployment.web_app]
}