resource "aws_secretsmanager_secret" "atlas_secret" {
  name = var.atlas_secret_name

}

resource "aws_secretsmanager_secret_version" "atlas_secret_version" {

  secret_id = aws_secretsmanager_secret.atlas_secret.id

   secret_string = jsonencode({

    USERNAME = var.db_username

    PASSWORD = random_password.db_password.result

    MONGO_URI = replace(
      mongodbatlas_cluster.ecs_cluster.connection_strings[0].standard_srv,
      "mongodb+srv://",
      "mongodb+srv://${var.db_username}:${random_password.db_password.result}@"
    )


    JWT_SECRET =  random_password.jwt_secret.result

    SERVICE_ACCOUNT_SECRET = try(
      mongodbatlas_organization.ecs_task_org.service_account[0].secrets[0].secret,
      null
    )
    

  })
}


