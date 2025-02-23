# 4 Subnets - 2 Private and 2 Public
# Public Subnet in AZ1
resource "aws_subnet" "public_subnet_1" {
  vpc_id                  = aws_vpc.ChatApp-VPC.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-2a"
  map_public_ip_on_launch = true
  tags = {
    Name = "ChatApp-PubSub-AZ1"
  }
}

# Public Subnet in AZ2
resource "aws_subnet" "public_subnet_2" {
  vpc_id                  = aws_vpc.ChatApp-VPC.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "us-east-2b"
  map_public_ip_on_launch = true
  tags = {
    Name = "ChatApp-PubSub-AZ2"
  }
}

# Private Subnet in AZ1
resource "aws_subnet" "private_subnet_1" {
  vpc_id                  = aws_vpc.ChatApp-VPC.id
  cidr_block              = "10.0.3.0/24"
  availability_zone       = "us-east-2a"
  map_public_ip_on_launch = false
  tags = {
    Name = "ChatApp-PvtSub-AZ1"
  }
}

# Private Subnet in AZ2
resource "aws_subnet" "private_subnet_2" {
  vpc_id                  = aws_vpc.ChatApp-VPC.id
  cidr_block              = "10.0.4.0/24"
  availability_zone       = "us-east-2b"
  map_public_ip_on_launch = false
  tags = {
    Name = "ChatApp-PvtSub-AZ2"
  }
}

# Create Internet Gateway
resource "aws_internet_gateway" "ChatApp-Igw" {
  vpc_id = aws_vpc.ChatApp-VPC.id
  tags = {
    Name = "ChatApp-IGW"
  }
}

# Public Route Table
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.ChatApp-VPC.id
  tags = {
    Name = "Public-RT"
  }
}

# Public Route
resource "aws_route" "public_route" {
  route_table_id         = aws_route_table.public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.ChatApp-Igw.id
}

# Association of Public Subnets 1 and 2 with Public Route Table
resource "aws_route_table_association" "public_association_1" {
  subnet_id      = aws_subnet.public_subnet_1.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "public_association_2" {
  subnet_id      = aws_subnet.public_subnet_2.id
  route_table_id = aws_route_table.public_rt.id
}

# Private Route Table
resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.ChatApp-VPC.id
  tags = {
    Name = "Private-RT"
  }
}

# Association of Private Subnets 1 and 2 with Private Route Table
resource "aws_route_table_association" "private_association_1" {
  subnet_id      = aws_subnet.private_subnet_1.id
  route_table_id = aws_route_table.private_rt.id
}

resource "aws_route_table_association" "private_association_2" {
  subnet_id      = aws_subnet.private_subnet_2.id
  route_table_id = aws_route_table.private_rt.id
}

# NAT Table Creation
resource "aws_eip" "nat_eip" {
  vpc = true
}

resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public_subnet_1.id
}

resource "aws_route" "private_nat_route" {
  route_table_id         = aws_route_table.private_rt.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_gateway.id
}
