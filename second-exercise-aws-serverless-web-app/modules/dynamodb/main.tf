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
  hash_key = var.default_hash_key
  read_capacity = var.read_capacity
  write_capacity = var.write_capacity

  attribute {
    name = var.default_hash_key
    type = var.default_hash_key_type
  }

  dynamic "attribute" {
    for_each = toset(var.dynamodb_attributes)
    content {
      name = attribute.value["name"]
      type = attribute.value["type"]
}
  }

  tags = merge(var.tags, {
    DeployTime = timestamp()
  })
}