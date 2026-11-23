output "vpc_id" {
  value = aws_vpc.tf_vpc.id
}

output "public_subnet_ids" {
  value = aws_subnet.public_subnet[*].id
}

output "private_subnet_ids" {
  value = aws_subnet.private_subnet[*].id
}

output "private_route_table_ids" {
  value = aws_route_table.private_route_table[*].id
}
output "security_group_id" {
  value = aws_security_group.tf_sg.id
}