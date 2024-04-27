variable "instance_name" {
  description = "Value of the Name tag for the EC2 instance"
  type        = string
  default     = "ExampleAppServerInstance"
}

variable "home_file_name" {
  description = "Value of the name of file placed in AMI's default user folder"
  type        = string
  default     = "hello-world.txt"
}

variable "home_file_content" {
  description = "Content of the file placed in AMI's default user folder"
  type        = string
  default     = "foo"
}

variable "home_template_file_name" {
  description = "Value of the name/path of the Template file"
  type        = string
  default     = "user-data.sh.tpl"
}

variable "ami_name" {
  description = "Value of the AMI name"
  type        = string
  default     = "ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"
}

variable "ami_owner" {
  description = "Value of the AMI owner"
  type        = string
  default     = "099720109477"
}

variable "aws_region" {
  description = "Value of the AWS Region"
  type = string
  default = "eu-west-1"
}