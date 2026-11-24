# Project 2.0 - AWS Infrastructure with Terraform

This project builds and evolves an AWS infrastructure from a basic EC2 deployment into a modular, load-balanced, observable application environment.

Each phase is kept as a separate snapshot so the infrastructure journey can be reviewed or deployed independently.

## Project Outcome

The final configuration provisions:

- A VPC with public and private subnets across availability zones.
- Internet and NAT gateways for public and private network routing.
- A public Application Load Balancer.
- A private EC2 Auto Scaling Group with Dockerized application instances.
- S3 application storage and private S3 endpoint access.
- SSM, CloudWatch, and Secrets Manager IAM integrations.
- Encrypted Terraform state stored in S3.
- CloudWatch logs, metrics, alarms, dashboard, and SNS email alerts.

## Phases

| Phase | What I Built |
|---|---|
| [Phase 1](phase-1.0/) | Created the first AWS foundation: VPC, public subnet, internet gateway, route table, EC2 instance, SSM role, and versioned S3 bucket. |
| [Phase 2](phase-2.0/) | Converted infrastructure into modules, created the remote-state backend |
| [Phase 3](phase-3.0/) | Added a modular EC2 and Docker deployment using a network module, compute module, IAM role/module, versioned S3 storage, and a secure S3 backend. |
| [Phase 4](phase-4.0/) | Extended the EC2 design with Secrets Manager, restricted secret IAM access, CloudWatch Agent logs and host metrics, CPU alarms, SNS email notifications, and a dashboard. |
| [Phase 5](phase-5.0/) | Completed the production-style architecture with public/private network segmentation, NAT egress, ALB ingress, private EC2 autoscaling, IAM, secrets, storage, and CloudWatch monitoring. |

## Progression

```text
Phase 1
Basic EC2 and S3
        |
        v
Phase 2
Remote state + reusable modules
        |
        v
Phase 3
Modular Docker EC2 deployment
        |
        v
Phase 4
Secrets and CloudWatch observability
        |
        v
Phase 5
Complete load-balanced AWS architecture
```

## Final Architecture

The Phase 5 layout uses the following module responsibilities:

- **Network:** VPC, public/private subnets, internet gateway, NAT gateways, route tables, security group, and S3 endpoint.
- **Ingress:** Application Load Balancer, HTTP listener, target group, security groups, launch template, and Auto Scaling Group.
- **Roles:** EC2 trust policy, instance profile, SSM access, CloudWatch permissions, and scoped Secrets Manager access.
- **Secret:** Application database URL and API key stored in AWS Secrets Manager.
- **Storage:** Versioned S3 application bucket and imported existing bucket support.
- **Observability:** CloudWatch log groups, Agent metrics/log collection, CPU alarm, SNS topic, email subscription, and dashboard.

## Remote State

Application environments use an S3 backend:

- State is encrypted and versioned.
- Native S3 state locking is enabled.
- Development state uses `environments/dev/terraform.tfstate`.
- Bootstrap infrastructure is managed separately so it is not accidentally removed by an application environment.

The bootstrap configuration is included in the Phase 2 and Phase 3 snapshots.

## Prerequisites

- Terraform CLI
- AWS CLI
- An AWS account
- AWS credentials with permission to create the listed resources
- An email address for SNS alert confirmation

Verify AWS access:

```powershell
aws sts get-caller-identity
terraform version
```

## Deploying a Phase

For a phase containing a bootstrap directory, provision the backend first:

```powershell
cd phase-2.0\bootstrap
terraform init
terraform validate
terraform plan
terraform apply
```

Then deploy the development environment:

```powershell
cd ..\environments\dev
terraform init
terraform validate
terraform plan
terraform apply
```

For phases that only contain an environment root, run the deployment commands directly from `environments\dev`.

For Phase 5, the development root composes the network, storage, roles, secret, observability, and ingress modules.

## Validation

After deployment:

- Confirm the ALB DNS name in Terraform outputs.
- Verify the target group reports healthy instances.
- Check private EC2 instances in the Auto Scaling Group.
- Confirm application and system log groups in CloudWatch.
- Check CPU/network metrics in the dashboard.
- Confirm the SNS email subscription.
- Verify the Secrets Manager secret and scoped EC2 role access.

## Security Practices

- Keep state and secret values out of Git.
- Enable S3 encryption and versioning.
- Block public access to Terraform state.
- Use HTTPS-only backend access.
- Restrict application traffic through ALB and EC2 security groups.
- Scope secret access to the required secret ARN.
- Use SSM instead of exposing SSH access.
- Protect Terraform state with native locking.
- Store the bootstrap state securely and keep it independent from application destruction.

## Cleanup

Destroy the application environment first:

```powershell
cd environments\dev
terraform destroy
```

Then destroy the bootstrap backend only when intentionally decommissioning the complete project:

```powershell
cd ..\..\bootstrap
terraform destroy
```
