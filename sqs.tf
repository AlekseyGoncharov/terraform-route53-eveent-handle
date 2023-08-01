resource "aws_sqs_queue" "route53-events-queue" {
  name                    = "route53-events-queue"
  sqs_managed_sse_enabled = true
  tags = {
    "Env": "security"
  }
}


data "aws_iam_policy_document" "route53-sqs-policy" {
  statement {
    sid    = "First"
    effect = "Allow"

    principals {
      type        = "*"
      identifiers = ["*"]
    }

    actions   = ["sqs:SendMessage"]
    resources = [aws_sqs_queue.route53-events-queue.arn]

    condition {
      test     = "ArnEquals"
      variable = "aws:SourceArn"
      values   = [aws_cloudwatch_event_rule.route53-events.arn]
    }
  }
}

resource "aws_sqs_queue_policy" "route53-events-queue" {
  queue_url = aws_sqs_queue.route53-events-queue.id
  policy    = data.aws_iam_policy_document.route53-sqs-policy.json
}


