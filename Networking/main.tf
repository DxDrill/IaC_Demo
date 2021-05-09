#----Create VPC------#
resource "aws_vpc" "main" {
    cidr_block = var.vpc_cidr
    tags = {
        Name = "main"
    }
}
#----Crate Private Subnet-----#
resource "aws_subnet" "private_subnet" {
    vpc_id = aws_vpc.main.id
    cidr_block = var.private_cidr
    availability_zone = "us-east-1d"
    map_public_ip_on_launch = false
    tags = {
        Name = "private_subnet"
    }
}

#----Create Public Subnet----#
resource "aws_subnet" "public_subnet_1" {
    vpc_id = aws_vpc.main.id
    cidr_block = var.public_cidr_1
    availability_zone = "us-east-1a"
    map_public_ip_on_launch = "true"
    tags = {
        Name = "public_subnet_1"
    }
}

resource "aws_subnet" "public_subnet_2" {
    vpc_id = aws_vpc.main.id
    cidr_block = var.public_cidr_2
    availability_zone = "us-east-1b"
    map_public_ip_on_launch = "true"
    tags = {
        Name = "public_subnet_2"
    }
}

resource "aws_subnet" "public_subnet_3" {
    vpc_id = aws_vpc.main.id
    cidr_block = var.public_cidr_3
    availability_zone = "us-east-1c"
    map_public_ip_on_launch = "true"
    tags = {
        Name = "public_subnet_3"
    }
}

#-----Create Internet Gateway-------#
resource "aws_internet_gateway" "gw" {
    vpc_id = aws_vpc.main.id
    tags = {
        Name = " Internet Gateway"
    }
}

/* Elastic IP for NAT */
resource "aws_eip" "nat_eip" {
  vpc        = true
  depends_on = [aws_internet_gateway.gw]
}

/* NAT */
resource "aws_nat_gateway" "gw1" {
    allocation_id = aws_eip.nat_eip.id
    subnet_id     = aws_subnet.public_subnet_3.id
    depends_on    = [aws_internet_gateway.gw]
    tags = {
        Name = "Nat Gateway"
    }
}

#-----Create Route Table----------#
resource "aws_route_table" "public-route-table" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
  tags = {
    Name = "public-route-table"
  }
}

#-------Create Private Route Table---------#
resource "aws_route_table" "private-route-table" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.gw1.id
  }
  tags = {
    Name = "private-route-table"
  }
}


#------Associate subnet with Route Table--------#
resource "aws_route_table_association" "public-1" {
  subnet_id = aws_subnet.public_subnet_1.id
  route_table_id = aws_route_table.public-route-table.id
}

resource "aws_route_table_association" "public-2" {
  subnet_id = aws_subnet.public_subnet_2.id
  route_table_id = aws_route_table.public-route-table.id
}

resource "aws_route_table_association" "public-3" {
  subnet_id = aws_subnet.public_subnet_3.id
  route_table_id = aws_route_table.public-route-table.id
}

resource "aws_route_table_association" "private" {
  subnet_id = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.private-route-table.id
}

#-----Create Security group-------#
resource "aws_security_group" "allow_web_traffic" {
  name = "allow_web_traffic"
  vpc_id = aws_vpc.main.id
  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Default"
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Allow_web"
  }
}
