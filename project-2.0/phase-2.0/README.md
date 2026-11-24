# Terraform AWS Infrastructure – Phase 2

A modular AWS infrastructure project built with **Terraform**. This project focuses on provisioning AWS resources using reusable modules, managing dependencies between resources, and practicing Infrastructure as Code (IaC).

## Overview

The infrastructure is divided into four independent modules:

- **Network:** Creates a VPC, subnets, Internet Gateway, route table, and security group.
- **Compute:** Provisions EC2 instances with configurable instance types and encrypted EBS storage.
- **Storage:** Creates an S3 bucket with versioning enabled.
- **IAM:** Creates an EC2 IAM role and instance profile with AWS Systems Manager access.

The root configuration connects these modules and passes resource information between them through module inputs and outputs.

## Architecture

```text
                  Terraform Root
                        |
          +-------------+-------------+
          |             |             |
        Network       Compute       Storage
          |             |             |
          |          EC2 Instance    S3 Bucket
          |             |
          |          EBS (gp3)
          |          Encrypted
          |
          +---------- IAM Roles
                        |
                  EC2 Instance Profile
                        |
                 Amazon SSM Access
```

## Project Structure

```text
phase-2.0/
│
├── main.tf
├── provider.tf
│
└── modules/
    │
    ├── network/
    │   ├── network.tf
    │   ├── variable.tf
    │   └── output.tf
    │
    ├── compute/
    │   ├── compute.tf
    │   ├── variable.tf
    │   └── output.tf
    │
    ├── storage/
    │   ├── storage.tf
    │   └── output.tf
    │
    └── roles/
        ├── roles.tf
        └── output.tf
```

## AWS Resources

| Module | Resources |
|---|---|
| Network | VPC, Subnets, Internet Gateway, Route Table, Security Group |
| Compute | EC2 Instances, Encrypted EBS Volume |
| Storage | S3 Bucket, Bucket Versioning |
| IAM | IAM Role, Policy Attachment, Instance Profile |

## Key Terraform Concepts

This project provides hands-on experience with:

- **Module-based architecture:** Separating infrastructure into reusable components.
- **Input variables:** Passing configuration into modules.
- **Output values:** Sharing resource IDs and attributes between modules.
- **Resource dependencies:** Connecting resources using references and module outputs.
- **Maps and objects:** Managing structured configuration.
- **Dynamic resource creation:** Using `count` and `for_each`.
- **Conditional configuration:** Selecting EC2 instance types based on the environment.
- **Variable validation:** Restricting environment values to supported options.
- **Infrastructure security:** Encrypted EBS storage and IAM-based EC2 access.

## Configuration

### Prerequisites

Make sure you have the following installed:

- [Terraform](https://developer.hashicorp.com/terraform/install)
- [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)
- An AWS account
- Configured AWS credentials with the required IAM permissions

### AWS Authentication

Configure your AWS credentials before running Terraform:

```bash
aws configure
```

The provider is currently configured for:

```hcl
provider "aws" {
  region = "us-east-1"
}
```

You can change the region in `provider.tf` if needed.

### Important Configuration

Before deployment, review the module variables and make sure:

- The EC2 AMI is valid for your selected AWS region.
- The instance configuration contains the required subnet, security group, IAM profile, and key pair values.
- Subnet CIDR blocks belong to the configured VPC CIDR range.
- The S3 bucket name is globally unique.
- Your AWS identity has permission to create the required resources.

## Deployment

Initialize the Terraform working directory:

```bash
terraform init
```

Validate the configuration:

```bash
terraform validate
```

Review the execution plan:

```bash
terraform plan
```

Provision the infrastructure:

```bash
terraform apply
```

Confirm the deployment when prompted.

### Inspect Outputs

```bash
terraform output
```

The compute module exposes:

- EC2 instance ID
- EC2 public IP address

The storage module exposes the S3 bucket name.

## Cleanup

To remove the resources created by this project:

```bash
terraform destroy
```

Review the destruction plan and confirm when prompted.

**Note:** Terraform-managed resources will be deleted. Back up any important data stored in the S3 bucket before destroying the infrastructure.

## Known Configuration Issues

The current configuration should be reviewed before deployment:

1. The network module defines a VPC CIDR of `10.1.0.0/16`, while the dynamically created subnets use `10.0.x.0/24` CIDRs. These subnet ranges need to be corrected.
2. The compute module's `instance_config` defaults contain null values for required EC2 configuration. Supply valid values before deployment.
3. The security group currently defines outbound HTTPS access but does not define inbound access rules.
4. The root module passes some compute inputs separately, while the EC2 resource reads its configuration from `instance_config`. Ensure these values are connected correctly.

These should be resolved before expecting a successful `terraform apply`.

## Learning Objective

The main objective of this phase is to understand how to design and manage AWS infrastructure using a modular Terraform architecture instead of maintaining all resources in a single configuration file.

The project establishes the foundation for more advanced infrastructure automation, security, and deployment workflows.

---

**Author:** [Ali Hassan](https://github.com/Alihassandev1)

**Repository:** [Terraform Projects](https://github.com/Alihassandev1/Terraform-projects.)
