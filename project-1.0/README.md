# Project 1.0

This Terraform project creates a small AWS lab environment for learning and testing cloud infrastructure. It provisions a VPC, a public subnet, internet access, a security group, three EC2 instances, and an S3 bucket.

## What gets created

- VPC: `10.1.0.0/16`
- Public subnet: `10.1.1.0/24`
- Internet gateway and public route table
- Security group allowing:
  - SSH from a specific IP (`39.35.190.142/32`)
  - HTTP from anywhere (`0.0.0.0/0`)
- Three EC2 instances:
  - `tf_server`
  - `tf_server2`
  - `tf_server3`
- S3 bucket: `tf-bucket-2024.bucket.io`

## Prerequisites

Before running this project, ensure that:

- Terraform is installed
- You have an AWS account
- AWS credentials are configured locally
- An EC2 key pair named `myacc` exists in the target region

## Run it

From the `project-1.0` directory:

```bash
terraform init
terraform plan
terraform apply
```

To remove everything:

```bash
terraform destroy
```

## Important notes

- The SSH rule is restricted to a single IP. Update it to your own public IP before using it in a real environment.
- The instances are launched in a public subnet and include public IP assignment.
- This is a simple demo setup, not a production-grade architecture.
