variable "image_url" {}

variable "container_port" {
  default = 4000
}

variable "execution_role_arn" {}

variable "task_role_arn" {}

variable "private_subnets" {}

variable "backend_sg_id" {}

variable "target_group_arn" {}