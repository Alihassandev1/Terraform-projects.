resource "aws_subnet" "public_subnet" {
    count = length(var.availability_zones)
    vpc_id = aws_vpc.tf_vpc.id
    cidr_block = var.public_subnet_cidr[count.index]
    map_public_ip_on_launch = true

    tags = {
      Name = "${var.project_name}-public_subnet-${count.index + 1}"
      tier = "public"
    }
}

resource "aws_subnet" "private_subnet" {
    count = length(var.availability_zones)
    vpc_id = aws_vpc.tf_vpc.id
    cidr_block = var.private_subnet_cidr[count.index]
    map_public_ip_on_launch = false

    tags = {
      Name = "${var.project_name}-private_subnet-${count.index + 1}"
      tier = "private"
    }
}