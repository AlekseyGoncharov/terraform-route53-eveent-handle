variable "tags" {
  type = map(string)
  default = {
    "env"        = "security"
    "managed_by" = "terraform"
    "purpose"    = "route53 events"
  }
}