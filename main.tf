terraform {
  required_version = ">= 1.0.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "ap-southeast-1" # Change to your preferred region
}

resource "aws_instance" "server1" {
  ami           = "ami-0933f1385008d33c4"
  instance_type = "t2.micro"
  user_data     = base64encode(templatefile("script.sh", {
    server2_private_ip = aws_instance.server2.private_ip
  }))
  vpc_security_group_ids = [aws_security_group.server1.id]
  depends_on = [aws_instance.server2]

  tags = {
    Name = "Server1"
  }
}

resource "aws_instance" "server2" {
  ami           = "ami-0933f1385008d33c4"
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.server2.id]

  tags = {
    Name = "Server2"
  }
}

resource "aws_security_group" "server1" {
  name_prefix = "server1"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "server2" {
  name_prefix = "server2"

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    security_groups = [aws_security_group.server1.id]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

output "server1_public_ip" {
  value = aws_instance.server1.public_ip
}
