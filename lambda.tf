data "archive_file" "lambda" {
  type = "zip"
  source {
    content = templatefile("main.py", {
      LOG_GROUP  = aws_cloudwatch_log_group.route53-events.name
      LOG_STREAM = aws_cloudwatch_log_stream.route53-events-lambda.name
    })
    filename = "main-rendered.py"
  }
  output_path = "lambda_payload.zip"
}

resource "aws_lambda_function" "route53-events-handler" {
  filename         = "lambda_payload.zip"
  function_name    = "route53_events_handler"
  role             = aws_iam_role.lambda_role.arn
  runtime          = "python3.10"
  publish          = "true"
  handler          = "main-rendered.lambda_handler"
  source_code_hash = data.archive_file.lambda.output_base64sha256

  tags = var.tags
}

resource "aws_lambda_event_source_mapping" "route53-events" {
  function_name    = aws_lambda_function.route53-events-handler.function_name
  event_source_arn = aws_sqs_queue.route53-events-queue.arn
}


