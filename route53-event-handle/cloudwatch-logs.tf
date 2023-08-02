resource "aws_cloudwatch_log_group" "route53-events" {
  name = var.log_group_name

  tags = var.tags
}

resource "aws_cloudwatch_log_stream" "route53-events-lambda" {
  name           = var.log_stream_name
  log_group_name = aws_cloudwatch_log_group.route53-events.name
}