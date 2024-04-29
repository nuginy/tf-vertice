variable "dynamodb_name" {
  description = "Value of the DynamoDb name"
  type = string
  default = "HelloWorldDatabase"
}

variable "dynamodb_attributes" {
  description = "Value of DynamoDb table attributes - name and type, list of maps"
  type = list(map(any))
  default = []
}

variable "tags" {
  description = "Value of the tags"
  type = map(string)
  default = {
    ENV = "Dev"
    PROJECT = "TF-Vertice-MZ"
  }
}

variable "default_hash_key" {
  description = "Value of the Hash Key of the Dynamodb table"
  type = string
  default = "ID"
}

variable "default_hash_key_type" {
  description = "Type of the Hash Key of the Dynamodb table"
  type = string
  default = "S"
}

variable "read_capacity" {
  description = "Value of the Dynamodb table Read Capacity"
  type = number
  default = 1
}

variable "write_capacity" {
  description = "Value of the Dynamodb table Write Capacity"
  type = number
  default = 1
}

