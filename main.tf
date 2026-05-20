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

module "Database" {
  source = "./Database"

  org_name             = var.org_name
  service_account_name = var.service_account_name
  project_name         = var.project_name
  cluster_name         = var.cluster_name
  db_username          = var.db_username
  db_name              = var.db_name
  atlas_secret_name    = var.atlas_secret_name
  aws_region           = var.aws_region
}

module "IAM" {
  source = "./Backend/IAM"

  secret_arn = module.Database.secret_arn

  depends_on = [module.Database]

}

module "ALB" {
  source = "./Backend/ALB"

  vpc_id          = module.vpc.vpc_output
  public_subnets  = module.vpc.public_subnets
  alb_sg_id       = module.alb_sg.alb_sg_id

  container_port  = var.container_port
}

module "ecr" {
  source = "./Backend/ecr"
}

module "ecs" {
  source = "./Backend/ecs"

  repo_url      = module.ecr.repo_url
  container_port = var.container_port

  execution_role_arn = module.IAM.execution_role_arn

  task_role_arn = module.IAM.task_role_arn

  private_subnets = module.vpc.private_subnets
  backend_sg_id = module.sg.sg_id

  target_group_arn = module.ALB.target_group_arn

  secret_arn = module.Database.secret_arn
}

module "Frontend" {
  source = "./Frontend"

  alb_dns = module.ALB.alb_dns


  bucket_name = var.bucket_name

}




