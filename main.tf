terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = var.region
}

# Create an EC2 Instance
resource "aws_instance" "web_server" {
  ami           = data.aws_ami.amazon_linux_2.id
  instance_type = var.instance_type

  key_name = var.key_name
  security_groups = [
    aws_security_group.allow_ssh_and_http.name
  ]

  tags = {
    Name = var.server
    Type = var.demo
  }

  user_data = <<EOF
#!/bin/bash
sudo yum update -y
sudo amazon-linux-extras install -y epel
sudo yum install -y httpd
sudo systemctl enable httpd
sudo systemctl start httpd
sudo systemctl status httpd
echo "<html><head><title>Hello from AWS!</title></head><body><h1>Hello from AWS!</h1></body></html>" | sudo tee /var/www/html/index.html > /dev/null
EOF
}

# Get AMI ID
data "aws_ami" "amazon_linux_2" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn2-ami-kernel-5.10-hvm-*-x86_64-gp2"]
  }
}

# Create a Security Group to allow SSH and HTTP traffic
resource "aws_security_group" "allow_ssh_and_http" {
  name = "allow_ssh_and_http"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allow SSH from anywhere (for demonstration purposes, restrict this in production)
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allow HTTP from anywhere (for demonstration purposes, restrict this in production)
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"] # Allow all outbound traffic
  }

}
