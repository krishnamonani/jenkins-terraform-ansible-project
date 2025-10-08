# Security group for SSH and HTTP access
resource "aws_security_group" "tf_ansible_sg" {
  name        = "tf-ansible-sg"
  description = "Allow SSH and HTTP"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description = "SSH access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.allowed_ssh_cidr]
  }

  ingress {
    description = "HTTP access"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "tf-ansible-sg"
  }
}

# Get the default VPC automatically
data "aws_vpc" "default" {
  default = true
}

# Create EC2 instance
resource "aws_instance" "app" {
  ami                         = var.ami
  instance_type               = var.instance_type
  key_name                    = var.ssh_key_name
  vpc_security_group_ids      = [aws_security_group.tf_ansible_sg.id]
  associate_public_ip_address = true

  tags = {
    Name = "tf-ansible-instance"
  }

#   # Write the public IP to Ansible inventory file
#   provisioner "local-exec" {
#     command = "echo ${self.public_ip} > ../ansible/inventory.ini"
#   }
}

