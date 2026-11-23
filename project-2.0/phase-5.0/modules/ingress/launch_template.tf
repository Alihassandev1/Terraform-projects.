resource "aws_launch_template" "app" {
  name_prefix   = "${var.project_name}-template-"
  image_id      = var.ami_id
  instance_type = var.instance_type

  vpc_security_group_ids = [
    aws_security_group.ec2.id
  ]

  iam_instance_profile {
    name = var.instance_profile_name
  }

  user_data = base64encode(
    templatefile("${path.module}/user_data.sh", {
      docker_image = var.docker_image
      app_port     = var.app_port
      log_group    = var.log_group_name
      aws_region   = "us-east-1"
    })
  )

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }

  block_device_mappings {
    device_name = "/dev/xvda"

    ebs {
      volume_size           = 20
      volume_type           = "gp3"
      encrypted             = true
      delete_on_termination = true
    }
  }

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "${var.project_name}-instance"
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}