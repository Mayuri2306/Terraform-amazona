variable "image_url" {
  default = "nginx:latest"
}

variable "container_port" {}

variable "execution_role_arn" {}

variable "private_subnets" {}

variable "backend_sg_id" {}

variable "target_group_arn" {}