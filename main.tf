provider "aws" {
  region = var.region
}

resource "aws_vpc" "default" {
  cidr_block = "10.0.0.2/16"
  tags = {
    Name = "wordpress-vpc"
  }
}

resource "aws_subnet" "public" {
  vpc_id = aws_vpc.default.id
  cidr_block = "10.0.0.0/24"
  availability_zone = "us-east-1a"
  tags = {
    Name = "wordpress-public-subnet"
  }
}

resource "aws_security_group" "public" {
  name = "wordpress-public-sg"
  description = "Security group for the WordPress public subnet"
  vpc_id = aws_vpc.default.id

  ingress {
    from_port = 80
    to_port = 80
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

resource "aws_instance" "wordpress" {
  ami = "ami-01234567890123456"
  instance_type = "t2.micro"
  key_name = "my-key-pair"
  security_groups = ["wordpress-public-sg"]
  subnet_id = aws_subnet.public.id
}
