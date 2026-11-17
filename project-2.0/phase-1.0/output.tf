output "vpc_id" {
  value = aws_vpc.tf_vpc.id
}

output "subnet_id" {
  value = aws_subnet.public_subnet.id
}

output "instance_id" {
  value = aws_instance.terraform-server.id
}

output "instance_public_ip" {
  value = aws_instance.terraform-server.public_ip
}

output "s3_bucket_name" {
  value = aws_s3_bucket.tf_bucket.bucket
}