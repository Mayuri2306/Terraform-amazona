module "vpc" {
  source = "./Backend/vpc"

  vpc_cidr        = var.vpc_cidr
  pub_sub_1_cidr  = var.pub_sub_1_cidr
  pub_sub_2_cidr  = var.pub_sub_2_cidr
  pri_sub_1_cidr  = var.pri_sub_1_cidr
  pri_sub_2_cidr  = var.pri_sub_2_cidr
}

module "alb_sg" {
  source = "./Backend/alb_sg"

  vpc_id = module.vpc.vpc_output
}


module "sg" {
  source = "./Backend/sg"

  vpc_id = module.vpc.vpc_output

  alb_sg_id = module.alb_sg.alb_sg_id
}

module "IAM" {
  source = "./Backend/IAM"

  secret_arn = module.Database.secret_arn
}

module "ALB" {
  source = "./Backend/ALB"

  vpc_id          = module.vpc.vpc_output
  public_subnets  = module.vpc.public_subnets
  alb_sg_id       = module.alb_sg.alb_sg_id

  container_port  = var.container_port
}

module "ecs" {
  source = "./Backend/ecs"

  image_url      = var.image_url
  container_port = var.container_port

  execution_role_arn = module.IAM.execution_role_arn

  task_role_arn = module.IAM.task_role_arn

  private_subnets = module.vpc.private_subnets
  backend_sg_id = module.sg.sg_id

  target_group_arn = module.ALB.target_group_arn

  secret_arn = module.Database.secret_arn
}

module "ecr" {
  source = "./Backend/ecr"
}

module "Frontend" {
  source = "./Frontend"

  alb_dns = module.ALB.alb_dns


  bucket_name = var.bucket_name

}

module "Database" {
  source = "./Database"

}


