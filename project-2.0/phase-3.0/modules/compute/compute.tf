resource "aws_instance" "terraform-server" {
  ami = var.instance_config.ami
  instance_type = var.instance_type[var.environment]
  subnet_id = var.instance_config.subnet_id
  vpc_security_group_ids = var.instance_config.vpc_security_group_ids
  associate_public_ip_address = var.instance_config.associate_public_ip_address
  iam_instance_profile = var.instance_config.iam_instance_profile
  key_name = var.instance_config.key_name
  user_data = templatefile("${path.module}/templates/fastapi.sh.tftpl", {
    container_name = var.container_name
    docker_image = var.docker_image
  })

   root_block_device {
    volume_size = 10
    volume_type = "gp3"

    encrypted = true
  }
  
  tags = {
    Name = "terraform-server"
  }
}

resource "aws_instance" "terraform-servers-loop" {
  ami = var.instance_config.ami
  count = 3
  instance_type = var.instance_type[var.environment]
  subnet_id = var.instance_config.subnet_id
  vpc_security_group_ids = var.instance_config.vpc_security_group_ids
  associate_public_ip_address = var.instance_config.associate_public_ip_address
  iam_instance_profile = var.instance_config.iam_instance_profile
  key_name = var.instance_config.key_name
  
  tags = {
    Name = "terraform-server-${count.index + 2}"
  }
}