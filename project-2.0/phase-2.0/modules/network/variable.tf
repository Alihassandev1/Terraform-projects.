variable "vpc_cidr" {
  description = "The CIDR block for the VPC"
  default     = "10.1.0.0/16"
}

variable "subnet_cidr" {
  description = "The CIDR block for the subnet"
  default     = "10.1.1.0/24"
}

variable "subnets" {
  type = map(object({
    cidr_block        = string
    availability_zone = string
  }))
  default = {
    "public-1" = {
      cidr_block        = "10.0.1.0/24"
      availability_zone = "us-east-1a"
    }
    "public-2" = {
      cidr_block        = "10.0.2.0/24"
      availability_zone = "us-east-1b"
    }
    "private-1" = {
      cidr_block        = "10.0.3.0/24"
      availability_zone = "us-east-1a"
    }
  }
}