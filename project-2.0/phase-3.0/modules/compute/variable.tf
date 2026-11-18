variable "environment" {
  description = "The environment for the instance"
  type = string
  default = "dev"
  validation {
    condition     = contains(["dev", "prod"], var.environment)
    error_message = "Environment must be either 'dev' or 'prod'."
  }
}
variable "instance_type" {
  description = "The type of instance to create"
  type = map(string)
  default = {
    "dev" = "t3.small"
    "prod" = "t3.medium"
  }
}
variable "instance_config" {
  description = "The configuration for the instance"
  type = object({
    ami = string
    subnet_id = string
    vpc_security_group_ids = list(string)
    associate_public_ip_address = bool
    iam_instance_profile = string
    key_name = string
  })
  default = {
    ami = null
    subnet_id = null
    vpc_security_group_ids = []
    associate_public_ip_address = false
    iam_instance_profile = null
    key_name = null
  }
}

variable "vpc_id" {
  description = "The ID of the VPC"
  type = string
}

variable "subnet_id" {
  description = "The ID of the subnet"
  type = string
}

variable "security_group_id" {
  description = "The ID of the security group for the instance"
  type = string
}

variable "iam_instance_profile" {
  description = "The name of the IAM instance profile"
  type = string
}

variable "container_name" {
  description = "The name of the container"
  type = string
}

variable "docker_image" {
  description = "The image of the container"
  type = string
}