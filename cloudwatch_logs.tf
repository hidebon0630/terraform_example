resource "aws_s3_bucket" "cloudwatch_logs" {
  bucket = "cloudwatch_logs-pragmatic-hidebon0630-terraform-s3-bucket"

  lifecycle_rule {
    enabled = true

    expiration {
      days = "180"
    }
  }
}
