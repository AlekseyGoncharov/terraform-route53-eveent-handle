resource "aws_cloudwatch_log_group" "route53-events" {
  name = "Route53-events"

  tags = {
    Environment = "production"
    Application = "serviceA"
  }
}

resource "aws_cloudwatch_log_stream" "route53-events-lambda" {
  name           = "from_lambda"
  log_group_name = aws_cloudwatch_log_group.route53-events.name
}