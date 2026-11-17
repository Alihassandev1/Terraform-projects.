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