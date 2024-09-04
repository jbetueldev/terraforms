resource "aws_dynamodb_table" "tf_activity_dynamo" {
  name         = "tf-activity-dynamo"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
  tags = {
    Name = "DynamoDB Table Terraform Activity Backend"
  }
}