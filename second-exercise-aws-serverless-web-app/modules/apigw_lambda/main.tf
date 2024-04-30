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
#     Imported module for enabling CORS    #
############################################

module "cors" {
  source  = "squidfunk/api-gateway-enable-cors/aws"
  version = "0.3.3"

  api_id          = aws_api_gateway_rest_api.web_app.id
  api_resource_id = aws_api_gateway_rest_api.web_app.root_resource_id
  allow_methods   = ["POST", "OPTIONS"]
}

############################################
#               Rest API GW                #
############################################

resource "aws_api_gateway_rest_api" "web_app" {
  name = "${var.apigw_name_prefix}Tf"
  endpoint_configuration {
    types = var.apigw_endpoint_types
  }
  tags = merge(var.tags, {
    DeployTime = timestamp()
  })
}

resource "aws_api_gateway_method" "post" {
  authorization = var.apigw_method_auth
  http_method   = var.apigw_method_http_method
  resource_id   = aws_api_gateway_rest_api.web_app.root_resource_id
  rest_api_id   = aws_api_gateway_rest_api.web_app.id
  depends_on    = [aws_api_gateway_rest_api.web_app]
}

############################################
#  Api Gw Integration and Method response  #
############################################

resource "aws_api_gateway_method_response" "post" {
  http_method     = aws_api_gateway_method.post.http_method
  resource_id     = aws_api_gateway_rest_api.web_app.root_resource_id
  rest_api_id     = aws_api_gateway_rest_api.web_app.id
  status_code     = "200"
  response_models = contains(keys(var.method_response_response_models), "application/json") ? var.method_response_response_models : merge(var.method_response_response_models, {
    "application/json" = "Empty"
  })
  response_parameters = contains(keys(var.integration_response_response_parameters), "method.response.header.Access-Control-Allow-Origin") ? var.integration_response_response_parameters : merge(var.integration_response_response_parameters, {
    "method.response.header.Access-Control-Allow-Origin" = true
  })
  depends_on = [aws_api_gateway_method.post]
}

resource "aws_api_gateway_integration_response" "post" {
  http_method         = aws_api_gateway_method.post.http_method
  resource_id         = aws_api_gateway_rest_api.web_app.root_resource_id
  rest_api_id         = aws_api_gateway_rest_api.web_app.id
  status_code         = "200"
  response_parameters = contains(keys(var.integration_response_response_parameters), "method.response.header.Access-Control-Allow-Origin") ? var.integration_response_response_parameters : merge(var.integration_response_response_parameters, {
    "method.response.header.Access-Control-Allow-Origin" = "'*'"
  })
  depends_on = [aws_api_gateway_method.post, aws_api_gateway_integration.lambda]
}

############################################
#   Rest Api Gw Integration with Lambda    #
############################################

resource "aws_api_gateway_integration" "lambda" {
  http_method             = aws_api_gateway_method.post.http_method
  resource_id             = aws_api_gateway_rest_api.web_app.root_resource_id
  rest_api_id             = aws_api_gateway_rest_api.web_app.id
  type                    = "AWS"
  integration_http_method = var.apigw_method_http_method
  uri                     = aws_lambda_function.lambda_function.invoke_arn
  depends_on              = [aws_api_gateway_method.post, aws_lambda_function.lambda_function]
}

############################################
#           Rest Api Gw Deployment         #
############################################

resource "aws_api_gateway_deployment" "web_app" {
  rest_api_id = aws_api_gateway_rest_api.web_app.id
  depends_on  = [aws_api_gateway_method.post, aws_api_gateway_integration.lambda]
}

############################################
#            Rest Api Gw Stage             #
############################################

resource "aws_api_gateway_stage" "web_app" {
  deployment_id = aws_api_gateway_deployment.web_app.id
  rest_api_id   = aws_api_gateway_rest_api.web_app.id
  stage_name    = var.env
  depends_on    = [aws_api_gateway_deployment.web_app]
  tags          = merge(var.tags, {
    DeployTime = timestamp()
  })
}