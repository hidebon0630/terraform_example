resource "aws_s3_bucket" "cloudwatch_logs" {
  bucket = "cloudwatch_logs-pragmatic-hidebon0630-terraform-s3-bucket"

  lifecycle_rule {
    enabled = true

    expiration {
      days = "180"
    }
  }
}

data "aws_iam_policy_document" "kinesis_data_firehose" {
  statement {
    effect = "Allow"

    actions = [
      "s3:AbortMultipartUpload",
      "s3:GetBucketLocation",
      "s3:GetObject",
      "s3:ListBucket",
      "s3:ListBucketMultipartUploads",
      "s3:PutObject",
    ]

    resources = [
      "arn:aws:s3:::${aws_s3_bucket.cloudwatch_logs.id}",
      "arn:aws:s3:::${aws_s3_bucket.cloudwatch_logs.id}/*",
    ]
  }
}

module "kinesis_data_firehose_role" {
  source = "./iam_role"
  name = "kinesis_data_firehose"
  identifier = "firehose.amazonaws.com"
  policy = data.aws_iam_policy_document.kinesis_data_firehose.json
}

resource "aws_kinesis_firehose_delivery_stream" "example" {
  name = "example"
  destination = "s3"

  s3_configuration {
    role_arn = module.kinesis_data_firehose_role.iam_role_arn
    bucket_arn = aws_s3_bucket.cloudwatch_logs.arn
    prefix = "ecs-scheduled-tasks/example/"
  }
}
