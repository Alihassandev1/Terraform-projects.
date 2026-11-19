variable "docker_image" {
  type = string
  default = "nginx:latest"
}

variable "container_name" {
  type =  string
  default = "my-container"
}

variable "api_key" {
  type = string
  default = "fchgjklq90q843yruioj4ktn4123qredgfjkl"
}

variable "database_url" {
  type = string
  default = "mysql://user:password@host:port/db"
}

variable "environment" {
  type = string
  default = "dev"
}