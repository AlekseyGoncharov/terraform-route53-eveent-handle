module "sqs" {
  source  = "terraform-aws-modules/sqs/aws"
  version = "= 4.0.2"
  name    = "route53-events-queue"

  create_dlq = true
  redrive_policy = {
    # default is 5 for this module
    maxReceiveCount = 10
  }

  queue_policy_statements = {
    eventbridge_rule = {
      sid     = "EventBridgeRulePush"
      actions = ["sqs:SendMessage"]

      principals = [
        {
          type        = "Service"
          identifiers = ["sns.amazonaws.com"]
        }
      ]

      conditions = [{
        test     = "ArnEquals"
        variable = "aws:SourceArn"
        values   = [module.eventbridge.arn]
      }]
    },
    lambda_rule = {
      sid     = "LambdaGetMessage"
      actions = ["sqs:DeleteMessage", "sqs:ReceiveMessage", "sqs:GetQueueAttributes"]

      principals = [
        {
          type        = "Service"
          identifiers = ["lambda.amazonaws.com"]
        }
      ]

      conditions = [{
        test     = "ArnEquals"
        variable = "aws:SourceArn"
        values   = [module.eventbridge.arn]
      }]
    }
  }
}

