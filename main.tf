provider "aws" {
  profile = "default"
  region  = var.region
}

data "aws_vpc" "default" {
  default = true
}

resource "aws_instance" "aws_ubuntu" {
  instance_type          = var.instance_type
  ami                    = var.ami
  user_data              = file("userdata.sh")
}

resource "aws_security_group" "demo_sg" {
  name        = "demo_sg"
  description = "allow ssh on 22 & http on port 80"
  vpc_id      = aws_vpc.default.id

  ingress {
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
}