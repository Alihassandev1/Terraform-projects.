variable "project_name" {
  description = "The name of the project"
  default     = "final-architecture"
}

variable "vpc_id" {
  description = "The ID of the VPC"
  type        = string
}

variable "app_port" {
  description = "The port on which the application is running"
  type        = number
  default     = 80
}

variable "public_subnet_ids" {
  description = "List of public subnet IDs"
  type        = list(string)
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs"
  type        = list(string)
}

variable "instance_type" {
  description = "The EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "docker_image" {
  description = "The Docker image to be used for the application"
  type        = string
}

variable "instance_profile_name" {
  description = "The name of the IAM instance profile"
  type        = string
}

variable "ami_id" {
  description = "The AMI ID for the EC2 instance"
  type        = string
  default     = "ami-0dbbc5f94779f577b" # Amazon Linux 2 AMI
}

variable "container_name" {
  description = "The name of the Docker container"
  type        = string
  default     = "myapp"
}