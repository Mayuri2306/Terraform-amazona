resource "aws_ecs_cluster" "application_cluster" {
  name = "application-cluster"
}


resource "aws_ecs_task_definition" "task_def" {
  family                   = "backend"
  requires_compatibilities = ["FARGATE"]
  network_mode            = "awsvpc"
  cpu                     = "256"
  memory                  = "512"

  execution_role_arn = var.execution_role_arn
  task_role_arn      = var.task_role_arn

  container_definitions = jsonencode([{
    name  = "backend"
    image = var.image_url

    essential = true

    portMappings = [{
      containerPort = var.container_port
    }]
  }])
}


resource "aws_ecs_service" "service" {
  name            = "backend-service"
  cluster         = aws_ecs_cluster.application_cluster.id
  task_definition = aws_ecs_task_definition.task_def.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets         = var.private_subnets
    security_groups = [var.backend_sg_id]
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = var.target_group_arn
    container_name   = "backend"
    container_port   = var.container_port
  }

  depends_on = [aws_ecs_cluster.application_cluster]
}