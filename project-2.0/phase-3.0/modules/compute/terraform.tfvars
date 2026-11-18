instance_config = {
    ami = "ami-0c14f4b0615aa1193"
    subnet_id = var.subnet_id
    vpc_security_group_ids = [var.security_group_id]
    associate_public_ip_address = true
    iam_instance_profile = var.iam_instance_profile
    key_name = "myacc"
}

environment = "dev"
container_name = "my-container"
docker_image = "nginx:latest"
instance_type = {
    "dev" = "t3.small"
    "prod" = "t3.medium"
}