# Frontend Instance
resource "aws_instance" "frontend_instance_1" {
  ami           = "ami-020d4488bb739b210"   # Use the frontend AMI
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.public_subnet_1.id
  key_name      = "chatapp-keypair-001" 
  security_groups = [aws_security_group.frontend_sg.id]

  tags = {
    Name = "Frontend-ChatApp"
  }
}

# Backend Instance
resource "aws_instance" "backend_instance" {
  ami           = "ami-0a4b1f1d5886dcdcb"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.private_subnet_1.id
  key_name      = "chatapp-keypair-001"
  security_groups = [aws_security_group.backend_sg.id]
  tags = {
    Name = "Backend-ChatApp"
  }
}

# DB Instance
resource "aws_instance" "db_instance" {
  ami           = "ami-0ae065ac8a41f1a4c"
  instance_type = "t2.micro"
  key_name      = "chatapp-keypair-001"
  subnet_id     = aws_subnet.private_subnet_2.id
  security_groups = [aws_security_group.db_sg.id]
  tags = {
    Name = "DB-ChatApp"
  }
}
