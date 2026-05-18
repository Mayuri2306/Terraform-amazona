resource "aws_lb" "app_alb" {
  name               = "app-alb"
  load_balancer_type = "application"
  internal           = false

  security_groups = [var.alb_sg_id]
  subnets         = var.public_subnets

}


resource "aws_lb_target_group" "app_tg" {
  name     = "app-tg"
  port     = var.container_port
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  target_type = "ip"

  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}


resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_lb.app_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app_tg.arn
  }
}