variable "apigw_name_prefix" {
  description = "Value of the name of the Api Gw App"
  type = string
  default = "HelloWorldAPI"
}

variable "apigw_endpoint_types" {
  description = "Value of the Api Gw Endpoint Type"
  type = list(string)
  default = [ "EDGE" ]
}

variable "apigw_method_auth" {
  description = "Value of the Api Gw Resource method authorization"
  type = string
  default = "NONE"
}

variable "apigw_method_http_method" {
  description = "Value of the Api Gw Resource method http method"
  type = string
  default = "POST"
}

variable "env" {
  description = "Value of the environment variable"
  type = string
  default = "dev"
}

variable "lambda_name" {
  description = "Value of the Lambda Function name"
  type = string
  default = "HelloWorldFunction"
}

variable "lambda_description" {
  description = "Value of the Lambda Function description"
  type = string
  default = "This lambda function waiting for input from api gw and store inputs to dynamodb table and return result"
}

variable "lambda_memory_size" {
  description = "Value of the Lambda Function memory size"
  type = number
  default = 128
}

variable "lambda_concurrency" {
  description = "Value of the Lambda Function concurrency setting"
  type = number
  default = -1
}

variable "lambda_handler" {
  description = "Valuo of the Lambda Function handler"
  type = string
  default = "lambda_function.lambda_handler"
}

variable "lambda_path" {
  description = "Value of the path to the Lambda Function source code in our code base"
  type = string
  default = "./code/lambda_code/lambda_function.py"
}

variable "dynamodb_arn" {
  description = "Value of the Dynamodb arn"
  type = string
}

variable "lambda_policies" {
  description = "Value of the Aws Lambda policy, List of Maps"
  type = list(map(any))
  default = []
}

variable "integration_response_response_parameters" {
  description = "Value of the response parameters block for Api Gw Integration Response"
  type = map(any)
  default = {}
}

variable "method_response_response_parameters" {
  description = "Value of the response parameters block for Api Gw Method Response"
  type = map(any)
  default = {}
}

variable "method_response_response_models" {
  description = "Value of the response models block for Api Gw Method Response"
  type = map(any)
  default = {}
}

variable "tags" {
  description = "Value of the tags"
  type = map(string)
  default = {
    ENV = "Dev"
    PROJECT = "TF-Vertice-MZ"
  }
}