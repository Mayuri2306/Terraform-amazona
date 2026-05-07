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

module "iam" {
  source = "./Backend/iam"
}

module "alb" {
  source = "./Backend/alb"

  vpc_id          = module.vpc.vpc_output
  public_subnets  = module.vpc.public_subnets
  alb_sg_id       = module.alb_sg.alb_sg_id

  container_port  = var.container_port
}

module "ecs" {
  source = "./Backend/ecs"

  image_url      = var.image_url
  container_port = var.container_port

  execution_role_arn = module.iam.execution_role_arn

  private_subnets = module.vpc.private_subnets
  sg_id           = module.sg.sg_id

  target_group_arn = module.alb.target_group_arn
}

module "frontend" {
  source = "./Frontend"

}


