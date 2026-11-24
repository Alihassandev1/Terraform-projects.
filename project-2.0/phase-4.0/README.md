# Phase 4 - Secrets and Observability

Phase 4 adds production-oriented security and operational monitoring to the modular EC2 architecture. It keeps the network, compute, storage, and role modules from Phase 3 and adds Secrets Manager and CloudWatch/SNS integrations.

## What I Built

### Network and Compute

- Modular VPC, public subnet, internet gateway, route table, and EC2 security group.
- Primary EC2 instance running a configurable Docker container.
- A loop-created set of three additional EC2 instances.
- SSM access through an EC2 instance profile.
- Docker startup through EC2 user data.
- Encrypted GP3 storage.

### Secrets Manager

- A dedicated application secret for the selected environment.
- A secret version containing:
  - `DATABASE_URL`
  - `API_KEY`
  - The secret ARN
- EC2 IAM access restricted to the application secret.
- Instance role permissions for CloudWatch log creation and delivery.

Sensitive values are supplied through Terraform variables rather than hard-coded in application resources. Real values must not be committed to Git.

### CloudWatch

- `/linkedops/application` log group for application logs.
- `/linkedops/system` log group for system logs.
- Seven-day log retention.
- CloudWatch Agent configuration for:
  - Application and system log files
  - Memory utilization
  - Disk utilization
  - Swap utilization
- EC2 CPU utilization alarm with an 80-percent threshold.
- Alarm evaluation over two five-minute periods.
- SNS email notification for the alarm.
- CloudWatch dashboard showing CPU utilization and network traffic.

### IAM

- EC2 service trust role.
- SSM and CloudWatch IAM policy attachments.
- Instance profile.
- Least-privilege secret read policy for the specific secret ARN.

### Storage

- Versioned S3 application bucket.

## Module Flow

The development root passes:

- Network outputs into the compute module.
- The instance profile from the roles module into EC2.
- The Secrets Manager secret ARN into the IAM role policy.
- The EC2 instance ID into the observability module.
- Environment and alert settings into secrets and observability.

## Deployment

Phase 4 uses the existing remote backend configuration:

```powershell
cd .\environments\dev
terraform init
terraform validate
terraform plan
terraform apply
```

After applying, confirm the SNS email subscription through the AWS account email inbox.

## Outputs

Terraform exposes:

- EC2 instance details and public IPs.
- S3 bucket name.
- Secrets Manager secret ID.
- IAM instance profile.
- CloudWatch log group name.

## Cleanup

```powershell
terraform destroy
```
