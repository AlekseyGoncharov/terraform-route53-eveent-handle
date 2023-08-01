resource "aws_cloudwatch_event_rule" "route53-events" {
  name        = "route53-events"
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

resource "aws_cloudwatch_event_target" "sqs" {
  rule      = aws_cloudwatch_event_rule.route53-events.name
  target_id = "SendToSQS"
  arn       = aws_sqs_queue.route53-events-queue.arn
}
