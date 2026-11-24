# Terraform AWS Projects

This repository contains a two-stage Terraform learning and infrastructure series for AWS. It progresses from a simple public EC2 lab to a modular, load-balanced application platform.

## Repository Structure

```text
Terraform/
├── project-1.0/
├── project-2.0/
│   ├── phase-1.0/
│   ├── phase-2.0/
│   ├── phase-3.0/
│   ├── phase-4.0/
│   └── phase-5.0/
├── deploy.sh
└── .gitignore
```

## Project 1.0

[Project 1.0](project-1.0/) is the introductory AWS lab. It creates:

- A VPC using `10.1.0.0/16`.
- A public subnet using `10.1.1.0/24`.
- An internet gateway and public route table.
- A security group allowing SSH from `39.35.190.142/32` and HTTP from the internet.
- Three `t3.micro` EC2 instances created with `for_each`.
- Public IP assignment in the public subnet.
- The S3 bucket `tf-bucket-2024.bucket.io`.

The AWS provider is configured for `us-east-1`. Before deployment, replace the fixed SSH source IP with your current public IP and ensure an EC2 key pair named `myacc` exists in the target region.

## Project 2.0

[Project 2.0](project-2.0/) presents five Terraform phases that progressively improve the architecture:

| Phase | Infrastructure |
|---|---|
| [Phase 1](project-2.0/phase-1.0/) | VPC, public subnet, internet gateway, EC2, SSM role/profile, encrypted storage, and versioned S3. |
| [Phase 2](project-2.0/phase-2.0/) | Secure S3 remote state, reusable modules. |
| [Phase 3](project-2.0/phase-3.0/) | Modular EC2 networking, public/private networking, Docker startup, SSM access, repeated EC2 instances, S3 storage, and remote state. |
| [Phase 4](project-2.0/phase-4.0/) | Secrets Manager, scoped IAM secret access, NAT, CloudWatch logs and host metrics, SNS alerts, CPU alarm, and dashboard. |
| [Phase 5](project-2.0/phase-5.0/) | Final public/private architecture with NAT, ALB, private autoscaling, Docker launch templates, Secrets Manager, S3, storage import, CloudWatch, and SNS. |

The final Phase 5 architecture uses public subnets for the internet-facing load balancer and NAT gateways, while application EC2 instances run in private subnets behind an Application Load Balancer. An Auto Scaling Group maintains between two and four instances.

## Architecture Progression

```text
Project 1.0
Public EC2 lab
      |
      v
Project 2.0 Phase 1
Network + EC2 + IAM + S3 foundation
      |
      v
Phase 2
Remote state + modules
      |
      v
Phase 3
Dockerized modular EC2 deployment
      |
      v
Phase 4
Secrets and operational observability
      |
      v
Phase 5
Complete segmented AWS application platform
```

## Prerequisites

- Terraform CLI
- AWS CLI
- AWS account and configured credentials
- IAM permissions for the resources being created
- EC2 key pair named `myacc` for configurations that use SSH key access
- Email access to confirm SNS subscriptions where applicable

Verify the local environment:

```powershell
terraform version
aws --version
aws sts get-caller-identity
```

## Deploy Project 1.0

```powershell
cd project-1.0
terraform init
terraform validate
terraform plan
terraform apply
```

Destroy it with:

```powershell
terraform destroy
```

## Deploy Project 2.0

Use one phase directory at a time. Phases with bootstrap infrastructure should deploy the bootstrap root before the development environment.

```powershell
cd project-2.0\phase-5.0\environments\dev
terraform init
terraform validate
terraform plan
terraform apply
```

Each phase README contains the exact resources and deployment sequence for that snapshot:

- [Project 2.0 overview](project-2.0/README.md)
- [Phase 1 README](project-2.0/phase-1.0/README.md)
- [Phase 2 README](project-2.0/phase-2.0/README.md)
- [Phase 3 README](project-2.0/phase-3.0/README.md)
- [Phase 4 README](project-2.0/phase-4.0/README.md)
- [Phase 5 README](project-2.0/phase-5.0/README.md)

## Remote State

The later Project 2.0 phases use an encrypted S3 backend with native state locking. Environment state is separated by backend key. Bootstrap roots create and protect the state bucket independently from application infrastructure.

State files and lock files must not be committed. The repository `.gitignore` excludes Terraform state, initialization directories, lock-info files, backend files, variable files, and local-only configuration.

## Security and Operations

- Keep AWS credentials outside Terraform source files.
- Do not commit real secrets or sensitive `.tfvars` files.
- Encrypt Terraform state and storage volumes.
- Use SSM for instance access where the configuration provides it.
- Restrict SSH and application access to required sources.
- Keep application instances in private subnets in the later phases.
- Scope IAM permissions to required secret ARNs and logging actions.
- Confirm SNS email subscriptions after applying notification infrastructure.
- Destroy application environments before their shared bootstrap backend.

## Cleanup

Destroy the active Terraform root before removing shared backend resources:

```powershell
terraform destroy
```

For Project 2.0, destroy `environments/dev` first. Keep bootstrap state until the complete setup is intentionally decommissioned.
