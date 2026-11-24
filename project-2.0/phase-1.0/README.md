# Phase 1 - AWS Foundation

This phase creates a small AWS environment from a single Terraform root. It establishes the networking, compute, IAM, and storage resources used by the later phases.

## What I Built

- An AWS VPC with a configurable CIDR block.
- One public subnet with automatic public IPv4 assignment.
- An internet gateway and public route table.
- A security group for the EC2 instance.
- An EC2 instance with SSM access, a `gp3` encrypted root volume, and a public IP.
- An IAM role and instance profile using `AmazonSSMManagedInstanceCore`.
- A versioned S3 application bucket.

The Terraform configuration also defines reusable variables for the VPC CIDR, subnet CIDR, and EC2 instance type.

## Files

| File | Purpose |
|---|---|
| `provider.tf` | Configures the AWS provider and provider version. |
| `variable.tf` | Defines network and EC2 input values. |
| `main.tf` | Creates all VPC, subnet, IAM, EC2, and S3 resources. |
| `output.tf` | Exposes VPC, subnet, instance, IP, and bucket details. |
| `terraform.tfvars` | Supplies environment-specific values. |

## AWS Region

The provider uses `us-east-1`.

## EC2 Access

The instance uses AWS Systems Manager Session Manager through its IAM instance profile. The root volume is encrypted and uses GP3 storage.

## Deployment

```powershell
cd C:\path\to\project-2.0\phase-1.0
terraform init
terraform validate
terraform plan
terraform apply
```

Review the outputs after deployment:

```powershell
terraform output
```

## Cleanup

```powershell
terraform destroy
```
