terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

provider "aws" {
  region = "us-east-1"
  default_tags {
    tags = {
      env        = "security"
      managed_by = "terraform"
      purpose    = "route53 events"
    }
  }
}
