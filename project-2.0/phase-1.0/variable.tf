variable "vpc_cidr" {
  description = "The CIDR block for the VPC"
  default     = "10.1.0.0/16"
}

variable "subnet_cidr" {
  description = "The CIDR block for the subnet"
  default     = "10.1.1.0/24"
}

variable "instance_type" {
  description = "The type of instance to create"
  default     = "t3.micro"
}

