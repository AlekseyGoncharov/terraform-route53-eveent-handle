terraform {
  backend "s3" {
    bucket         = "tfstate-route53-events-handler"
    dynamodb_table = "tfstate-lock-route53-events-handler"
    encrypt        = true
    key            = "route53-events-handler/terraform.tfstate"
    region         = "us-east-1"
  }
}