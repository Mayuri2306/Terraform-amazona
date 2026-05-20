output "org_id" {
    value = mongodbatlas_organization.ecs_task_org.org_id
}

output "service_account_secret" {
  value     = try(mongodbatlas_organization.ecs_task_org.service_account[0].secrets[0].secret, null)
  sensitive = true
}

output "project_id" {
    value = mongodbatlas_project.ecs_project.id
}

output "db_password" {
  value     = random_password.db_password.result
  sensitive = true
}

output "jwt_secret" {
  value     = random_password.jwt_secret.result
  sensitive = true
}

output "secret_arn" {
  value = aws_secretsmanager_secret.atlas_secret.arn
}

