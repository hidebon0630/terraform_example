resource "aws_s3_bucket" "force_destroy" {
  bucket = "force_destroy-pragmatic-terraform"
  force_destroy = true
}
