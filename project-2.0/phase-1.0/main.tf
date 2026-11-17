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

resource "aws_iam_role" "ec2_ssm_role" {
  name = "ec2-ssm-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "ssm" {
  role       = aws_iam_role.ec2_ssm_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "ec2_profile" {
  name = "ec2-ssm-profile"
  role = aws_iam_role.ec2_ssm_role.name
}

resource "aws_instance" "terraform-server" {
  ami = "ami-0d6dd9e8265d48906"
  instance_type = var.instance_type
  subnet_id = aws_subnet.public_subnet.id
  vpc_security_group_ids = [ aws_security_group.tf_sg.id ]
  associate_public_ip_address = true
  iam_instance_profile = aws_iam_instance_profile.ec2_profile.name
  key_name = "myacc"

   root_block_device {
    volume_size = 10
    volume_type = "gp3"

    encrypted = true
  }
  
  tags = {
    Name = "terraform-server"
  }
}


resource "aws_s3_bucket" "tf_bucket" {
  bucket = "tf-bucket-2026.bucket.io"
  tags = {
    Name = "tf_bucket"
  }
}

resource "aws_s3_bucket_versioning" "tf_bucket_versioning" {
  bucket = aws_s3_bucket.tf_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}