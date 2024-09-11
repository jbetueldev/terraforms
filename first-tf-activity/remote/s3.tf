resource "aws_s3_bucket" "tf_activity_bucket" {
  bucket = "tf-activity-bucket"
  tags = {
    Name = "S3 Bucket Terraform Activity Backend"
  }
}