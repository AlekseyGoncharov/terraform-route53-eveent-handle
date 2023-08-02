variable "tags" {
  type = map(string)
  default = {
    "env"        = "security"
    "managed_by" = "terraform"
    "purpose"    = "route53 events"
  }
}

variable "log_group_name" {
  type    = string
  default = "Route53-events"
}

variable "log_stream_name" {
  type    = string
  default = "from_lambda"
}
