# Terraform Project

This Terraform project creates a simple AWS networking and compute setup for a quick lab or demo environment. It provisions a VPC, a public subnet, an internet gateway, route table, security group, three EC2 instances, and an S3 bucket in the `us-east-1` region.

## What it deploys

- VPC: `10.1.0.0/16`
- Public subnet: `10.1.1.0/24`
- Internet gateway for public access
- Route table with default internet route
- Security group allowing SSH (port 22) from a specific IP and HTTP (port 80) from anywhere
- Three EC2 instances (`tf_server`, `tf_server2`, `tf_server3`)
- S3 bucket for storage

## Project structure

- `project-1.0/` — active Terraform configuration
  - `main.tf` — AWS resources
  - `provider.tf` — AWS provider configuration
- `second/` — placeholder directory for additional Terraform work

## Prerequisites

Before running this project, make sure you have:

- Terraform installed
- An AWS account
- AWS credentials configured locally (`aws configure` or environment variables)
- A valid EC2 key pair named `myacc`

## Quick start

1. Open a terminal in `project-1.0/`
2. Initialize Terraform:
   ```bash
   terraform init
   ```
3. Review the execution plan:
   ```bash
   terraform plan
   ```
4. Apply the configuration:
   ```bash
   terraform apply
   ```
5. When done, destroy the resources:
   ```bash
   terraform destroy
   ```

## Notes

- The security group allows SSH only from the IP configured in the code (`39.35.190.142/32`). Update it to match your own public IP before deployment.
- The EC2 instances use the `t3.micro` instance type and a public subnet with auto-assigned public IPs.
- This is a basic infrastructure lab, not a production-ready architecture.
