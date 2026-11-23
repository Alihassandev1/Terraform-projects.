variable "project_name" {
  description = "The name of the project"
  default     = "project-2.0"
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