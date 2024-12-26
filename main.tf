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
