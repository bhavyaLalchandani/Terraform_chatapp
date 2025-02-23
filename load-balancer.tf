# Load Balancer - Internet Facing
resource "aws_lb" "frontend_lb" {
  name               = "frontend-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb_sg.id]
  subnets            = [aws_subnet.public_subnet_1.id, aws_subnet.public_subnet_2.id]
  enable_deletion_protection = false

  tags = {
    Name = "frontend-alb"
  }
}

# Target Group for Frontend Instances
resource "aws_lb_target_group" "frontend_tg" {
  name     = "frontend-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.ChatApp-VPC.id

  health_check {
    path                = "/"  # Health check for root path
    interval            = 300
    timeout             = 60
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = {
    Name = "frontend-tg"
  }
}

# Listener for Load Balancer
resource "aws_lb_listener" "frontend_lb_listener" {
  load_balancer_arn = aws_lb.frontend_lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.frontend_tg.arn
  }
}
