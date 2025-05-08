terraform {
  required_version = ">=1.5"
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

}

provider "aws" {
  region = "us-east-2"
}

resource "aws_vpc" "web" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "subnet1" {
  vpc_id = aws_vpc.web.id
  cidr_block = "10.0.1.0/24"
  availability_zone = var.availability_zones

  tags = {
    Name = "Subnet1"
    Type = "Public"
  }
}



resource "aws_security_group" "webserver" {
  name = "webserver"
  description = "Webserver network traffic"
  vpc_id = aws_vpc.web.id

  ingress {
    description = "SSH form anywhere"
    from_port = 22
    to_port = 22
    protocol = "tcp"
  }

  ingress {
    description = "HTTP from anywhere"
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "webserver" {
  ami           = var.amis[var.region]
  instance_type = var.instance_type
  subnet_id     = aws_subnet.subnet1.id
  vpc_security_group_ids = [aws_security_group.webserver.id]

  associate_public_ip_address = true


  user_data = <<-EOF
  #!/bin/bash
  echo "Hello World" > index.html
  nohup busybox httpd -f -p 8080 &
  EOF

  user_data_replace_on_change = true



}