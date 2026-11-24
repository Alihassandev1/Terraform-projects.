# Phase 5 - Final Production-Style AWS Architecture

Phase 5 combines the completed modules into the final application architecture: secure remote state, segmented public/private networking, NAT egress, load balancing, EC2 autoscaling, Secrets Manager, IAM, storage, and CloudWatch observability.

## Final Architecture

- A public Application Load Balancer receives HTTP traffic.
- Public subnets contain the ALB and NAT gateways.
- Private subnets contain application EC2 instances.
- An Auto Scaling Group maintains two healthy instances and scales between two and four.
- EC2 instances run containers from launch-template user data.
- NAT gateways provide private-subnet outbound access.
- An S3 VPC endpoint provides private S3 access.
- Secrets Manager stores application configuration.
- CloudWatch and SNS provide logs, metrics, dashboards, alarms, and email alerts.

## What I Built

### Backend

The development environment uses an encrypted S3 backend with separate state keys and native S3 locking. Backend infrastructure is created and managed independently through the bootstrap roots from the earlier phases.

### Network

- VPC.
- Multiple public subnets across availability zones.
- Multiple private subnets across availability zones.
- Internet gateway.
- NAT gateways with elastic IPs.
- Public and private route tables.
- S3 gateway endpoint.
- Shared and tier-specific network tags.

### Application Ingress

- Internet-facing Application Load Balancer.
- HTTP listener and target group.
- `/health` target-group health checks.
- ALB security group allowing public HTTP.
- EC2 security group allowing application traffic only from the ALB.
- Launch template with Docker startup, IMDSv2, and an encrypted GP3 root volume.
- Auto Scaling Group in private subnets.
- ELB health checks and one-minute ASG metrics.
- Maintenance policy that keeps at least 90 percent of instances healthy.

### Compute Identity and Secrets

- EC2 IAM role with SSM and CloudWatch attachments.
- Instance profile attached through the launch template.
- Secrets Manager secret containing database URL and API key values.
- Secret read permissions scoped to the application secret.

### Storage

- Versioned application S3 bucket.
- Terraform-managed import for an existing S3 bucket.

### Observability

- Application and system log groups with seven-day retention.
- CloudWatch Agent collection for logs and host metrics.
- CPU alarm above 80 percent.
- SNS topic and email subscription.
- CloudWatch dashboard for CPU and network metrics.

## Module Flow

The development root connects modules in this order:

```text
network -> ingress
        -> observability
secret -> roles -> ingress
storage
```

The ingress module receives public and private subnet IDs from the network module and the IAM instance profile from the roles module.

## Project Layout

```text
phase-5.0/
├── environments/dev/
└── modules/
    ├── network/
    ├── ingress/
    ├── roles/
    ├── secret/
    ├── storage/
    └── observability/
```

## Deployment

```powershell
cd .\environments\dev
terraform init
terraform validate
terraform plan
terraform apply
```

Terraform outputs include the ALB DNS name and resource identifiers.

Confirm the SNS email subscription before relying on alarm notifications.

## Validation

After deployment:

- Check that the target group shows healthy instances.
- Open the ALB DNS name from an allowed HTTP client.
- Verify the Auto Scaling Group is running two instances across private subnets.
- Check application and system log groups in CloudWatch.
- Confirm CPU and network data in the dashboard.
- Verify Secrets Manager and IAM role attachments in AWS.

## Cleanup

Destroy application infrastructure before backend infrastructure:

```powershell
cd .\environments\dev
terraform destroy
```

Destroy the bootstrap state bucket only when intentionally decommissioning the complete project.
