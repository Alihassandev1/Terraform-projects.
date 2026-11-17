resource "aws_vpc" "tf_vpc" {
  cidr_block = "10.1.0.0/16"
  tags = {
    Name = "tf_vpc"
  }
}

resource "aws_subnet" "public_subnet" {
    vpc_id = aws_vpc.tf_vpc.id
    cidr_block = "10.1.1.0/24"
    map_public_ip_on_launch = true
    tags = {
      Name = "public_subnet"
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

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["39.35.190.142/32"]
  }

  ingress {
    description = "Allow HTTP"
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
    Name = "tf_sg"
  }
}

resource "aws_instance" "tf_server" {
  for_each = toset(["tf_server", "tf_server2", "tf_server3"])
  ami = "ami-0d6dd9e8265d48906"
  instance_type = "t3.micro"
  subnet_id = aws_subnet.public_subnet.id
  vpc_security_group_ids = [ aws_security_group.tf_sg.id ]
  key_name = "myacc"
  
  tags = {
    Name = "${each.key}"
  }
}

resource "aws_s3_bucket" "tf_bucket" {
  bucket = "tf-bucket-2024.bucket.io"
  tags = {
    Name = "tf_bucket"
  }
}

