variable "apigw_name_prefix" {
  description = "Value of the name of the Api Gw app"
  type = string
  default = "HelloWorldAPI"
}

variable "apigw_endpoint_types" {
  description = "Value of the Api Gw Endpoint Type"
  type = list(string)
  default = [ "EDGE" ]
}

variable "apigw_root_path" {
  description = "Value of the Api Gw root path"
  type = string
  default = "{proxy+}"
}

variable "apigw_method_auth" {
  description = "Value of the Api Gw resource method authorization"
  type = string
  default = "NONE"
}

variable "apigw_method_http_method" {
  description = "Value of the Api Gw resource method http method"
  type = string
  default = "POST"
}

variable "env" {
  default = "dev"
  description = "Allow to set up environment for deployment"
  type = string
}

variable "lambda_name" {
  default = "HelloWorldFunction"
  description = "Allow to set up name for lambda function, default save_golang_generated_files"
  type = string
}

variable "lambda_description" {
  default = "This lambda function waiting for input from api gw and store inputs to dynamodb table and return result"
  description = "Allow add description for lambda function"
  type = string
}

variable "lambda_memory_size" {
  default = 128
  description = "Allow to set up lambda function memory size, default 128"
  type = number
}

variable "lambda_concurrency" {
  description = "Allow to set up lambda concurrency reservation, default -1 (means unlimited)"
  type = number
  default = -1
}

variable "lambda_handler" {
  description = "Allow to set up handler function for lambda function, default main"
  type = string
  default = "lambda_function.lambda_handler"
}

variable "lambda_path" {
  default = "./code/lambda_code/lambda_function.py"
  description = "Allow to set up path from point of resource called to main.go, default ./modules/app/lambda_code/main.go"
  type = string
}

variable "dynamodb_arn" {
  description = "Value of dynamodb arn"
  type = string
}

variable "lambda_policies" {
  description = "Value of the Aws Lambda policy, List of Maps"
  type = list(map(any))
  default = []
}