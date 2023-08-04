module "eventbridge" {
  source = "terraform-aws-modules/eventbridge/aws"

  targets = {
    logs = [
      {
        name = "send-logs-to-sqs"
        arn  = aws_sqs_queue.queue.arn
      }
    ]
  }
  rules = {
    logs = {
      description = "Capture ChangeResourceRecordSets in route53"
      event_pattern = jsonencode({
        source = [
          "aws.route53"
        ]
        "detail-type" = [
          "AWS API Call via CloudTrail"
        ]
        "detail" = {
          "eventSource" = [
            "route53.amazonaws.com"
          ]
          "eventName" = [
            "ChangeResourceRecordSets"
          ]
        }
      })
    }
  }
}
