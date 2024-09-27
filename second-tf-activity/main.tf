resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true

  tags = {
    Name = "Terraform VPC"
  }
}

resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidr
  availability_zone       = var.az
  map_public_ip_on_launch = true

  tags = {
    Name = "Public Subnet"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "Terraform IG"
  }
}

resource "aws_route_table" "custom_rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "Custom Route Table"
  }
}

resource "aws_route_table_association" "public_subnet_asso" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.custom_rt.id
}

resource "aws_security_group" "my-sg" {
  name   = "my-sg"
  vpc_id = aws_vpc.main.id
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
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
}

resource "aws_instance" "ec2" {
  ami                    = "ami-066784287e358dad1"
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.public_subnet.id
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.my-sg.id]
  user_data              = <<-EOF
                                #!/bin/bash
                                yum update -y
                                yum install git -y
                                git config --global user.name "johnbetueldev"
                                git config --global user.email "johnbetuel.dev@gmail.com"
                                yum install docker -y
                                sudo systemctl start docker
                                sudo systemctl enable docker
                                sudo usermod -a -G docker ec2-user
                                curl -L https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
                                chmod +x /usr/local/bin/docker-compose
                              EOF
  connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = file("${var.key_name}.pem")        # AWS KEY PAIR SHOULD BE IN THE SAME FOLDER WHERE YOU RUN TERRAFORM COMMANDS
      host        = self.public_ip
  }

  provisioner "file" {
    source      = "/home/bulbasaur/.ssh/id_rsa"
    destination = "/home/ec2-user/.ssh/id_rsa"
  }

  provisioner "file" {
    source      = "/home/bulbasaur/.ssh/id_rsa.pub"
    destination = "/home/ec2-user/.ssh/id_rsa.pub"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod 400 /home/ec2-user/.ssh/id_rsa",
      "ssh-keyscan -t rsa github.com >> /home/ec2-user/.ssh/known_hosts",
    ]
  }

  provisioner "remote-exec" {
    inline = [
      "sleep 15",
      "git clone git@github.com:jbetueldev/PCC-todo-sample-app.git",
    ]
  }

  tags = {
    Name = "nodejs-mysql-${var.az}"
  }
}

output "Connect_to_nodejs-mysql-us-east-1a" {
  value = "ssh -i NodeJS-MySQL-Todo.pem ec2-user@${aws_instance.ec2.public_ip}"
}
