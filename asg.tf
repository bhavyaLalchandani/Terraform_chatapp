# Launch Template
resource "aws_launch_template" "frontend_launch_template" {
  name          = "frontend-launch-template"
  image_id      = "ami-020d4488bb739b210"  # Frontend AMI ID
  instance_type = "t2.micro"
  key_name      = "chatapp-keypair-001"
  vpc_security_group_ids = [aws_security_group.frontend_sg.id]

  lifecycle {
    create_before_destroy = true
  }
}

# Auto Scaling Group using Launch Template
resource "aws_autoscaling_group" "frontend_asg" {
  desired_capacity          = 3
  max_size                  = 5
  min_size                  = 1
  health_check_grace_period = 300
  health_check_type         = "EC2"
  launch_template {
    id      = aws_launch_template.frontend_launch_template.id
    version = "$Latest"
  }
  vpc_zone_identifier       = [aws_subnet.public_subnet_1.id, aws_subnet.public_subnet_2.id]
  target_group_arns         = [aws_lb_target_group.frontend_tg.arn]

  # Tags block to assign tags to instances launched by the ASG
  tag {
    key                 = "Name"
    value               = "frontend-chatapp"
    propagate_at_launch = true
  }

  depends_on = [aws_lb_listener.frontend_lb_listener]
}
