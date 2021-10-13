data "aws_iam_policy_document" "example" {
  name = "example"
  policy = data.aws_iam_policy_document.allow_describe_regions.json
}
