module "sqs" {
  source  = "terraform-aws-modules/sqs/aws"
  version = "= 4.0.2"
  name    = "route53-events-queue"

  create_dlq = true
  redrive_policy = {
    # default is 5 for this module
    maxReceiveCount = 10
  }
  create_queue_policy = true
  queue_policy_statements = {
    eventbridge_rule = {
      sid     = "EventBridgeRulePush"
      actions = ["sqs:SendMessage"]

      principals = [
        {
          type        = "Service"
          identifiers = ["events.amazonaws.com"]
        }
      ]

      conditions = [{
        test     = "ArnEquals"
        variable = "aws:SourceArn"
        values   = [module.eventbridge.eventbridge_rule_arns.logs]
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
        values   = [module.lambda_function.lambda_function_arn]
      }]
    }
  }
}

