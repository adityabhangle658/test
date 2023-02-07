# Create a VPC
resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = "${var.prefix}-vpc"
  }
}

# Create Internet Gateway for Public Subnets
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.prefix}-igw"
  }
}

# Create Management subnet
resource "aws_subnet" "management-subnet" {
  count                   = "${length(var.mgt_subnet_cidr)}"
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "${var.mgt_subnet_cidr[count.index]}"
  availability_zone       = var.region
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.prefix}-mgt-subnet-1a"
  }
}

# Creating an Elastic IP for the NAT Gateway!
resource "aws_eip" "eip-nat-gateway" {
  vpc = true

  tags = {
    Name = "${var.prefix}-eip-natg"
  }
}

# Creating NAT gateway
resource "aws_nat_gateway" "nat-gateway" {
  depends_on = [
    aws_eip.eip-nat-gateway
  ]

  # Allocating the Elastic IP to the NAT Gateway!
  allocation_id = aws_eip.eip-nat-gateway.id

  subnet_id = aws_subnet.management-subnet[0].id
  
  tags = {
    Name = "${var.prefix}-nat-gateway"
  }
}

# Create Management subnet route table
resource "aws_route_table" "management-rt" {
  vpc_id = "${aws_vpc.vpc.id}"
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "${var.prefix}-mgt-rt"
  }
}

# Create route table association for Management layer
resource "aws_route_table_association" "mgt-rt-assoc" {
  count          = "${length(var.app_subnet_cidr)}"
  subnet_id      = element(aws_subnet.management-subnet.*.id,count.index)
  route_table_id = aws_route_table.management-rt.id
}


# ------------------------------------------------------------------------ Tier 1 - Web Layer 

# Create Tier 1 Public Subnet for WEB - 1a
resource "aws_subnet" "web-subnet" {
  count                   = "${length(var.web_subnet_cidr)}"
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "${var.web_subnet_cidr[count.index]}"
  availability_zone       = var.region
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.prefix}-web-subnet"
  }
}

# Create route table for Web layer 
resource "aws_route_table" "web-rt" {
  vpc_id = aws_vpc.vpc.id


  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "${var.prefix}-web-rt"
  }
}

# Create route table association for Web layer
resource "aws_route_table_association" "web-rt-assoc" {
  count          = "${length(var.web_subnet_cidr)}"
  subnet_id      = element(aws_subnet.web-subnet.*.id,count.index)
  route_table_id = aws_route_table.web-rt.id
}

# Create security group for web layer
resource "aws_security_group" "web-sg" {
  name        = "${var.prefix}-web-sg"
  description = "Allow HTTP From All"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    description = "HTTP from all"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.prefix}-web-sg"
  }
}

# ------------------------------------------------------------------------ Tier 2 - App Layer 

# Create Tier 2 Public Subnet for App - 1a
resource "aws_subnet" "application-subnet" {
  count                   = "${length(var.app_subnet_cidr)}"
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "${var.app_subnet_cidr[count.index]}"
  availability_zone       = var.region
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.prefix}-app-subnet"
  }
}

# Create route table for App layer 
resource "aws_route_table" "app-rt" {
  vpc_id = aws_vpc.vpc.id


  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "${var.prefix}-app-rt"
  }
}

# Create route table association for App layer - subnet 1a
resource "aws_route_table_association" "app-rt-assoc" {
  count          = "${length(var.app_subnet_cidr)}"
  subnet_id      = element(aws_subnet.application-subnet.*.id,count.index)
  route_table_id = aws_route_table.app-rt.id
}

# Create security group for App layer
resource "aws_security_group" "app-sg" {
  name        = "${var.prefix}-app-sg"
  description = "Allow inbound traffic"
  vpc_id      = aws_vpc.vpc.id

  # Allow all from web layer
  ingress {
    description     = "Allow HTTP from web layer"
    from_port       = 0
    to_port         = 65535
    protocol        = "tcp"
    security_groups = [aws_security_group.web-sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.prefix}-app-sg"
  }
}

#  ------------------------------------------------------------------------ Tier 3 - DB Layer 

# Create Tier 3 Public Subnet for DB - 1a
resource "aws_subnet" "db-subnet" {
  count                   = "${length(var.db_subnet_cidr)}"
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "${var.db_subnet_cidr[count.index]}"
  availability_zone       = var.region
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.prefix}-db-subnet"
  }
}

# Creating a Route Table for the Nat Gateway!
resource "aws_route_table" "db-rt" {
  depends_on = [
    aws_nat_gateway.nat-gateway
  ]

  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat-gateway.id
  }

  tags = {
    Name = "Route Table for NAT Gateway"
  }

}

# Create route table association for DB layer - subnet 1a
resource "aws_route_table_association" "db-rt-assoc" {
  count          = "${length(var.db_subnet_cidr)}"
  subnet_id      = element(aws_subnet.db-subnet.*.id,count.index)
  route_table_id = aws_route_table.db-rt.id
}

# Create Database Security Group
resource "aws_security_group" "database-sg" {
  name        = "${var.prefix}-db-sg"
  description = "Allow inbound traffic from application layer"
  vpc_id      = aws_vpc.vpc.id

  # 3306 from web layer
  ingress {
    description     = "Allow traffic from web layer"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.web-sg.id]
  }

  # 3306 from app layer
  ingress {
    description     = "Allow traffic from application layer"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.app-sg.id]
  }

  egress {
    from_port   = 32768
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.prefix}-db-sg"
  }
}
