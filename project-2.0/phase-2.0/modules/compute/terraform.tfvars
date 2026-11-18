instance_config = {
    ami = "ami-0d6dd9e8265d48906"
    instance_type = var.instance_type
    subnet_id = var.subnet_id
    vpc_security_group_ids = [var.security_group_id]
    associate_public_ip_address = true
    iam_instance_profile = var.iam_instance_profile
    key_name = "myacc"
}

environment = "dev"