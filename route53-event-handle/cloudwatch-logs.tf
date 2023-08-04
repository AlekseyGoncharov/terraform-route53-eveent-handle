module "log_group" {
  source  = "terraform-aws-modules/cloudwatch/aws//modules/log-group"
  version = "= 4.3.0"
  name    = "my-app"
}

module "log_stream" {
  source         = "terraform-aws-modules/cloudwatch/aws//modules/log-stream"
  version        = "= 4.3.0"
  name           = var.log_stream_name
  log_group_name = module.log_group.name
}
