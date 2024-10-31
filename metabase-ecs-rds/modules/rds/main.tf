resource "aws_security_group" "general_purpose_rds_sg" {
  name        = "${var.environment_rds}-${var.location_rds}-general-purpose-rds-sg"
  description = "Security Group for ${var.environment_rds}-${var.location_rds}-general-purpose-rds"
  vpc_id      = var.vpc_rds
  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr_rds]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_db_subnet_group" "default_vpc_subnet_group" {
  name       = "default-vpc-subnet-group"
  subnet_ids = var.subnets_rds

  tags = {
    Name = "default-VPC-subnet-group"
  }
}

resource "aws_rds_cluster" "general_purpose_rds" {
  engine                      = "postgres"
  engine_version              = "15.8"
  cluster_identifier          = "${var.environment_rds}-${var.location_rds}-general-purpose-rds"
  master_username             = "postgres"
  manage_master_user_password = true
  db_cluster_instance_class   = "db.c6gd.medium" # "db.m6gd.large"
  storage_type                = "gp3"
  allocated_storage           = 200
  availability_zones          = var.azs_rds
  backup_retention_period     = 7
  db_subnet_group_name        = aws_db_subnet_group.default_vpc_subnet_group.name
  vpc_security_group_ids      = [aws_security_group.general_purpose_rds_sg.id]
  skip_final_snapshot         = true
}