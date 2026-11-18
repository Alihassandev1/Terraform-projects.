output "state_bucket_name" {
  description = "S3 bucket used by the dev and staging Terraform backends."
  value       = aws_s3_bucket.terraform_state.bucket
}
