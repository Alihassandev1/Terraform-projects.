variable "instance_type" {
  description = "The type of instance to create"
  default     = "t3.micro"
}

variable "vpc_id" {
  description = "The ID of the VPC"
  type = string
}

variable "subnet_id" {
  description = "The ID of the subnet"
  type = string
}