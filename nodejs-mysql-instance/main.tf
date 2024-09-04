resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true

  tags = {
    Name = "Terraform VPC"
  }
}

resource "aws_subnet" "public_subnets" {
  count                   = length(var.public_subnet_cidrs)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = element(var.public_subnet_cidrs, count.index)
  availability_zone       = element(var.azs, count.index)
  map_public_ip_on_launch = true

  tags = {
    Name = "Public Subnet ${count.index + 1}"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "Terraform IG"
  }
}

resource "aws_route_table" "second_rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "2nd Route Table"
  }
}

resource "aws_route_table_association" "public_subnet_asso" {
  count          = length(var.public_subnet_cidrs)
  subnet_id      = element(aws_subnet.public_subnets[*].id, count.index)
  route_table_id = aws_route_table.second_rt.id
}

resource "aws_security_group" "ssh-access" {
  name   = "ssh-access"
  vpc_id = aws_vpc.main.id
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "ec2" {
  ami                    = "ami-066784287e358dad1"
  instance_type          = "t2.micro"
  count                  = length(var.public_subnet_cidrs)
  subnet_id              = element(aws_subnet.public_subnets[*].id, count.index)
  key_name               = aws_key_pair.ec2_key.id
  vpc_security_group_ids = [aws_security_group.ssh-access.id]

  tags = {
    Name = "nodejs-mysql-${element(var.azs, count.index)}"
  }
}

resource "tls_private_key" "tf-ssh-key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "pem_file" {
  content         = tls_private_key.tf-ssh-key.private_key_pem
  filename        = "tf-ssh-key.pem"
  file_permission = "0400"
}

resource "aws_key_pair" "ec2_key" {
  public_key = tls_private_key.tf-ssh-key.public_key_openssh
}

output "Connect_to_nodejs-mysql-us-east-1a" {
  value = "ssh -i tf-ssh-key.pem ec2-user@${aws_instance.ec2[0].public_ip}"
}

output "Connect_to_nodejs-mysql-us-east-1b" {
  value = "ssh -i tf-ssh-key.pem ec2-user@${aws_instance.ec2[1].public_ip}"
}

output "Connect_to_nodejs-mysql-us-east-1c" {
  value = "ssh -i tf-ssh-key.pem ec2-user@${aws_instance.ec2[2].public_ip}"
}
