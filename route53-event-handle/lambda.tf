resource local_file "lambda" {
  content = templatefile("main.py", {
      LOG_GROUP  = var.log_group_name
      LOG_STREAM = var.log_stream_name
    })
  filename = "lambda.py"
}


module "lambda_function" {
  depends_on = [local_file.lambda]
  source  = "terraform-aws-modules/lambda/aws"
  version = "= 5.3.0"

  function_name = "route53_events_handler"
  description   = "Handle route53 events and add additional field"
  handler       = "lambda.lambda_handler"
  runtime       = "python3.10"
  source_path   = local_file.lambda.filename

  attach_policies = true
  policies = [
    "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole",
  "arn:aws:iam::aws:policy/service-role/AWSLambdaSQSQueueExecutionRole"]
  number_of_policies = 2

}


resource "aws_lambda_event_source_mapping" "route53-events" {
  function_name    = module.lambda_function.lambda_function_name
  event_source_arn = module.sqs.queue_arn
}


