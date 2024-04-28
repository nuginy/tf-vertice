terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.32.0"
    }
  }

  required_version = ">= 1.2.0"
}

resource "aws_dynamodb_table" "web_app" {
  name = "${var.dynamodb_name}Tf"
  hash_key = "ID"
  read_capacity = 1
  write_capacity = 1

  attribute {
    name = "ID"
    type = "S"
  }

  dynamic "attribute" {
    for_each = toset(var.dynamodb_attributes)
    content {
      name = attribute.value["name"]
      type = attribute.value["type"]
}
  }
}