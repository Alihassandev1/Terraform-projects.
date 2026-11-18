resource "aws_vpc" "tf_vpc" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = "tf_vpc"
  }
}

resource "aws_subnet" "public_subnet" {
    vpc_id = aws_vpc.tf_vpc.id
    cidr_block = var.subnet_cidr
    map_public_ip_on_launch = true

    tags = {
      Name = "public_subnet"
    }
}

resource "aws_subnet" "test-subnets" {
  for_each = var.subnets

  vpc_id            = aws_vpc.tf_vpc.id
  cidr_block        = each.value.cidr_block
  availability_zone = each.value.availability_zone

  tags = {
    Name = each.key
  }
}

resource "aws_internet_gateway" "tf_igw" {
  vpc_id = aws_vpc.tf_vpc.id
  tags = {
    Name = "tf_igw"
  }
}

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.tf_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.tf_igw.id
  }
  tags = {
    Name = "public_route_table"
  }
  
}

resource "aws_route_table_association" "route_table_association" {
    subnet_id = aws_subnet.public_subnet.id
    route_table_id = aws_route_table.public_route_table.id
}

resource "aws_security_group" "tf_sg" {
  name = "tf_sg"
  description = "Allow SSH"
  vpc_id = aws_vpc.tf_vpc.id

  egress {
    description = "Allow HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "tf_sg"
  }
}