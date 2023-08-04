module "eventbridge" {
  source  = "terraform-aws-modules/eventbridge/aws"
  version = "= 2.3.0"

  targets = {
    logs = [
      {
        name = "send-logs-to-sqs"
        arn  = module.sqs.queue_arn
      }
    ]
  }
  create_bus = false

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
