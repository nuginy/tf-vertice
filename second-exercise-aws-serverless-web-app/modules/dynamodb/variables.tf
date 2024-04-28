variable "dynamodb_name" {
  description = "Value of the DynamoDb prefix name"
  type = string
  default = "HelloWorldDatabase"
}

variable "dynamodb_attributes" {
  description = "Value of DynamoDb table attributes - name and type, list of maps"
  type = list(map(any))
  default = []
}