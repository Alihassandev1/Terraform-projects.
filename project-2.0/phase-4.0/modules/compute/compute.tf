resource "aws_instance" "terraform-server" {
  ami = "ami-0d6dd9e8265d48906"
  instance_type = var.instance_type[var.environment]
  subnet_id = var.subnet_id
  vpc_security_group_ids = [var.security_group_id]
  associate_public_ip_address = true
  iam_instance_profile = var.iam_instance_profile
  user_data_replace_on_change = true
  key_name = "myacc"
  user_data = templatefile("${path.module}/templates/fastapi.sh.tftpl", 
    {cloudwatch_config = file("${path.module}/cloudwatch-config.json")},
    {
    container_name = var.container_name
    docker_image   = var.container_docker_image
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
  ami = "ami-0d6dd9e8265d48906"
  count = 3
  instance_type = var.instance_type[var.environment]
  subnet_id = var.subnet_id
  vpc_security_group_ids = [var.security_group_id]
  user_data_replace_on_change = true
  associate_public_ip_address = true
  iam_instance_profile = var.iam_instance_profile
  key_name = "myacc"
  
  tags = {
    Name = "terraform-server-${count.index + 2}"
  }
}