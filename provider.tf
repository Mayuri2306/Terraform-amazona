provider "aws" {
    region = var.aws_region
}

terraform {
  required_providers {
    mongodbatlas = {
      source  = "mongodb/mongodbatlas"
      version = "2.12.0"
    }
  }
}

provider "mongodbatlas" {
  
}

terraform {
  backend "s3" {
    bucket         = "bucket-remote-tfstate"
    key            = "amazona-app/terraform.tfstate"
    region         = "us-west-2"
    use_lockfile   =  true
  }
}

