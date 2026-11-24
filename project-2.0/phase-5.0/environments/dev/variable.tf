variable "docker_image" {
  type = string
  default = "nginx:latest"
}

variable "container_name" {
  type =  string
  default = "my-container"
}

variable "api_key_" {
  type = string
  default = "fchgjklq90q843yruioj4ktn4123qredgfjkl"
}

variable "database_url_" {
  type = string
  default = "mysql://user:password@host:port/db"
}

variable "environment_" {
  type = string
  default = "dev"
}

variable "alert_email" {
  type = string
  default = "alihassan6266249@gmail.com"
}
