resource "mongodbatlas_organization" "ecs_task_org" {
  
  name = var.org_name

  service_account {
    name                       = var.service_account_name
    description                = "Service Account for terraform"
    roles                      = ["ORG_OWNER"]
    secret_expires_after_hours = 8760
  }
}


resource "mongodbatlas_project" "ecs_project" {
  name   = var.project_name
  org_id = mongodbatlas_organization.ecs_task_org.org_id
}

resource "mongodbatlas_cluster" "ecs_cluster" {
  project_id                  = mongodbatlas_project.ecs_project.id
  name                        = var.cluster_name
  provider_name               = "TENANT"   # Required for M0
  backing_provider_name       = "AWS"      # Cloud provider
  provider_region_name        = var.aws_region
  provider_instance_size_name = "M0"       
}

resource "mongodbatlas_project_ip_access_list" "ip_access" {
  project_id = mongodbatlas_project.ecs_project.id
  cidr_block = "0.0.0.0/0" 
  comment    = "Allow all IPs for testing"
}


resource "random_password" "db_password" {
  length  = 20
  special = false
  upper   = true
  lower   = true
  numeric = true
}


resource "mongodbatlas_database_user" "db_user" {
  username           = var.db_username
  password           = random_password.db_password.result
  project_id         = mongodbatlas_project.ecs_project.id
  auth_database_name = "admin"

  roles {
    role_name     = "readWriteAnyDatabase"
    database_name = var.db_name
  }
}



resource "random_password" "jwt_secret" {
  length  = 32
  special = true
}





