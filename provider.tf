provider "aws" {
    region = var.aws_region
}

provider "mongodbatlas" {
  client_id     = var.mongodbatlas_client_id
  client_secret = var.mongodbatlas_client_secret
}

terraform {
  backend "s3" {
    bucket         = "bucket-remote-tfstate"
    key            = "amazona-app/terraform.tfstate"
    region         = "us-west-2"
    use_lockfile   =  true
  }
}

