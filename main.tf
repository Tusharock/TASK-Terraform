provider "aws" {
  region = ap-south-1
}

resource "aws_vpc" "default" {
  cidr_block = "10.0.0.2/16"
  tags = {
    Name = "VPC-A"
  }
}

resource "aws_subnet" "public" {
  vpc_id = aws_vpc.default.id
  cidr_block = "10.0.0.0/24"
  availability_zone = "ap-south-1a"
  tags = {
    Name = "Public-subnet"
  }
}

resource "aws_security_group" "public" {
  name = "Public-sg"
  description = "Security group for the  public subnet"
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

resource "aws_subnet" "private" {
  vpc_id = aws_vpc.default.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "ap-south-1b"
  tags = {
    Name = "Private-subnet"
  }
}

resource "aws_security_group" "private" {
  name = "Private-sg"
  description = "Security group for the  private subnet"
  vpc_id = aws_vpc

resource "aws_instance" "wordpress" {
  ami = "ami-01234567890123456"
  instance_type = "t2.micro"
  key_name = "mumbai-key.pem"
  security_groups = ["Public-sg"]
  subnet_id = aws_subnet.public.id
}
aws rds create-db-instance --db-instance-identifier my-rds --db-instance-class db.t2.micro --engine MySQL --allocated-storage 20 --publicly-accessible false --vpc-security-group-ids -Private-sg 
RDS_ENDPOINT=$(aws rds describe-db-instances --db-instance-identifier my-rds --query 'DBInstances[0].Endpoint.Address' --output text)
