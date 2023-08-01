resource "aws_cloudtrail" "events-trail" {
  name                          = "events-trail"
  s3_bucket_name                = aws_s3_bucket.cloudtrail_s3_bucket.id
  s3_key_prefix                 = "prefix"
  include_global_service_events = false
  tags = {
    "Env": "security"
  }
}

resource "aws_s3_bucket" "cloudtrail_s3_bucket" {
  bucket        = "events-trail"
  force_destroy = true
  tags = {
    "Env": "security"
  }
}

data "aws_iam_policy_document" "cloudtrail_policy" {
  statement {
    sid    = "AWSCloudTrailAclCheck"
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }

    actions   = ["s3:GetBucketAcl"]
    resources = [aws_s3_bucket.cloudtrail_s3_bucket.arn]
    condition {
      test     = "StringEquals"
      variable = "aws:SourceArn"
      values   = ["arn:${data.aws_partition.current.partition}:cloudtrail:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:trail/events-trail"]
    }
  }

  statement {
    sid    = "AWSCloudTrailWrite"
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }

    actions   = ["s3:PutObject"]
    resources = ["${aws_s3_bucket.cloudtrail_s3_bucket.arn}/prefix/AWSLogs/${data.aws_caller_identity.current.account_id}/*"]

    condition {
      test     = "StringEquals"
      variable = "s3:x-amz-acl"
      values   = ["bucket-owner-full-control"]
    }
    condition {
      test     = "StringEquals"
      variable = "aws:SourceArn"
      values   = ["arn:${data.aws_partition.current.partition}:cloudtrail:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:trail/events-trail"]
    }
  }
}
resource "aws_s3_bucket_policy" "example" {
  bucket = aws_s3_bucket.cloudtrail_s3_bucket.id
  policy = data.aws_iam_policy_document.cloudtrail_policy.json
}

data "aws_caller_identity" "current" {}

data "aws_partition" "current" {}

data "aws_region" "current" {}