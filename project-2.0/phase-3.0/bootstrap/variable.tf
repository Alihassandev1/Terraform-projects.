variable "state_bucket_name" {
  description = "Globally unique S3 bucket name for Terraform state."
  type        = string
}

variable "aws_region" {
  description = "AWS region used for the state bucket."
  type        = string
  default     = "us-east-1"
}

variable "approved_principal_arns" {
  description = "IAM principal ARNs allowed to access environment state and lock files."
  type        = list(string)

  validation {
    condition     = length(var.approved_principal_arns) > 0
    error_message = "Add at least one approved operator or CI role ARN."
  }
}