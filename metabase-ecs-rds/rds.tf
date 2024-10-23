resource "aws_db_subnet_group" "default_vpc_subnet_group" {
  name       = "default-vpc-subnet-group"
  subnet_ids = var.subnets

  tags = {
    Name = "default-VPC-subnet-group"
  }
}

resource "aws_rds_cluster" "dev_london_general_purpose_rds" {
  engine                      = "postgres"
  engine_version              = "15.8"
  cluster_identifier          = "dev-london-general-purpose-rds"
  master_username             = "postgres"
  manage_master_user_password = true
  db_cluster_instance_class   = "db.c6gd.medium" # "db.m6gd.large"
  storage_type                = "gp3"
  allocated_storage           = 200
  availability_zones          = ["us-east-1a", "us-east-1b", "us-east-1c"] # ["eu-west-2a", "eu-west-2b", "eu-west-2c"]
  backup_retention_period     = 7
  iops                        = 3000
  db_subnet_group_name        = aws_db_subnet_group.default_vpc_subnet_group.name
  vpc_security_group_ids      = [aws_security_group.dev_london_general_purpose_rds_sg.id]
  skip_final_snapshot         = true
}
