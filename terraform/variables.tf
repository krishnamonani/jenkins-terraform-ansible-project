variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "instance_type" {
  type    = string
  default = "t2.micro"
}

variable "ami" {
  type    = string
  # Use an Ubuntu AMI id valid for your region; update if needed
  default = "ami-0360c520857e3138f"
}

variable "allowed_ssh_cidr" {
  type    = string
  default = "0.0.0.0/0" # for testing; tighten in production
}

variable "ssh_key_name" {
  type    = string
  default = "VPC-test"
  description = "The name of the existing EC2 KeyPair to use for SSH access to the instance."
}