terraform {
  backend "s3" {
    bucket         = "tf-activity-bucket"
    key            = "nodejs-mysql-instance/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "tf-activity-dynamo"
  }
}