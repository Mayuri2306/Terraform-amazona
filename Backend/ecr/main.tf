resource "aws_ecr_repository" "repo" {
    name = "backend-application"

    image_scanning_configuration {
    scan_on_push = true
  }
}