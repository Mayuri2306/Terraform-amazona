provider "aws" {
    region = var.aws_region
}

terraform {
  backend "s3" {
    bucket         = "bucket-remote-tfstate"
    key            = "amazona-app/terraform.tfstate"
    region         = "us-west-2"
    use_lockfile   =  true
  }
}

