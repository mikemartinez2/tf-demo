#!/bin/bash
export environment="${environment}"
sudo yum update -y
sudo amazon-linux-extras install -y epel
sudo yum install -y httpd
sudo systemctl enable httpd
sudo systemctl start httpd
sudo systemctl status httpd
echo "<html><head><title>Hello from my Terraform Sales Demo!</title></head><body><h1>Hello from my Terraform Sales Demo "${environment}"!</h1></body></html>" | sudo tee /var/www/html/index.html > /dev/null
