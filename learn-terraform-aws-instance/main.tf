terraform {
  cloud {
    organization = "tf_vertice_mz"
    workspaces {
      name = "learn-terraform-aws"
    }
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region = var.aws_region
}

data "aws_ami" "ubuntu_ami_latest" {
  owners      = [var.ami_owner]
  most_recent = true

  filter {
    name   = "name"
    values = [var.ami_name]
  }
}

resource "aws_instance" "app_server" {
  ami           = data.aws_ami.ubuntu_ami_latest.id
  instance_type = "t2.micro"
  user_data = templatefile(var.home_template_file_name, {
    f_name    = var.home_file_name
    f_content = var.home_file_content
  })
  user_data_replace_on_change = true
  lifecycle {
    create_before_destroy = var.create_new_before_terminate_old
  }
  tags = {
    Name = var.instance_name
  }
}
