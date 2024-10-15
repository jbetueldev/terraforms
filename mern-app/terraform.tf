terraform {
  backend "s3" {
    bucket         = "r3m0t3-s3-bucket"
    key            = "mern-app/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-state-table"
  }
}