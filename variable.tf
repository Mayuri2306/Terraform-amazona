variable "aws_region" {}

variable "vpc_cidr" {}

variable "pub_sub_1_cidr" {}

variable "pub_sub_2_cidr" {}

variable "pri_sub_1_cidr" {}

variable "pri_sub_2_cidr" {}

variable "image_url" {
    default = "nginx:latest"
}

variable "container_port" {}

variable "bucket_name" {}