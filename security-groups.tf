# Frontend Security Group
resource "aws_security_group" "frontend_sg" {
  name        = "frontend_sg"
  description = "Allow inbound traffic to frontend"

  vpc_id = aws_vpc.ChatApp-VPC.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    security_groups = [aws_security_group.lb_sg.id]  # Allow HTTP access from anywhere
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Allow SSH access from anywhere
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]  # Allow outbound traffic
  }
}

# Backend Security Group
resource "aws_security_group" "backend_sg" {
  name        = "backend_sg"
  description = "Allow traffic to backend from frontend"

  vpc_id = aws_vpc.ChatApp-VPC.id

  ingress {
    from_port   = 8000
    to_port     = 8000
    protocol    = "tcp"
    security_groups = [aws_security_group.frontend_sg.id]  # Allow traffic from frontend
  }

ingress {
    from_port   = 8000
    to_port     = 8000
    protocol    = "tcp"
    cidr_blocks = ["10.0.1.0/24"]  # Allow traffic from public sub 1
  }

ingress {
    from_port   = 8000
    to_port     = 8000
    protocol    = "tcp"
    cidr_blocks = ["10.0.2.0/24"]  # Allow traffic from public sub 2
  }

ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Allow ssh traffic
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# DB Security Group 
resource "aws_security_group" "db_sg" {
  name        = "db_sg"
  description = "Allow traffic to DB from backend"

  vpc_id = aws_vpc.ChatApp-VPC.id

  ingress {
    from_port   = 3306   # MySQL
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["10.0.3.0/24"]
  }

  ingress {
    from_port   = 3306   # MySQL
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["10.0.4.0/24"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Security Group for Load Balancer
resource "aws_security_group" "lb_sg" {
  name        = "frontend-alb-sg"
  description = "Allow inbound HTTP traffic to load balancer"

  vpc_id = aws_vpc.ChatApp-VPC.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Allow HTTP access from anywhere
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]  # Allow all outbound traffic
  }
}
