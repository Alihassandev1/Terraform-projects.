# Terraform Multi-Environment Infrastructure

A Terraform project demonstrating secure infrastructure provisioning on AWS using reusable modules, remote state management, native S3 state locking, and isolated development and staging environments.

The goal is to build infrastructure that is reusable, maintainable, and safe to manage across multiple environments without duplicating Terraform configurations.

## Architecture

The project follows a modular architecture with separate Terraform roots for backend provisioning and application environments.

```text
terraform-project/
│
├── bootstrap/
│   ├── main.tf
│   ├── variables.tf
│   ├── outputs.tf
│   └── terraform.tf
│
├── modules/
│   ├── vpc/
│   ├── compute/
│   └── security/
│
├── environments/
│   ├── dev/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── terraform.tf
│   │   └── terraform.tfvars
│   │
│   └── staging/
│       ├── main.tf
│       ├── variables.tf
│       ├── terraform.tf
│       └── terraform.tfvars
│
└── README.md
```

### How it works

- **Bootstrap:** Creates and secures the S3 bucket used for Terraform remote state.
- **Modules:** Contain reusable infrastructure configurations such as VPC, compute, and security.
- **Dev:** Manages development infrastructure using its own Terraform state.
- **Staging:** Uses the same modules with different configuration values and maintains an independent state.

## Key Features

### 1. Secure S3 Remote Backend

Terraform state is stored in an AWS S3 bucket rather than being maintained only on a developer's machine.

The backend includes:

- Server-side encryption for state files.
- S3 versioning for state recovery.
- S3 Block Public Access.
- HTTPS-only bucket policy.
- Restricted access for approved IAM operators and CI roles.
- Separate state keys for each environment.
- Native S3 state locking using `use_lockfile = true`.

### 2. Native State Locking

S3 native locking prevents concurrent Terraform operations from modifying the same state simultaneously.

```hcl
terraform {
  backend "s3" {
    bucket       = "YOUR_STATE_BUCKET"
    key          = "environments/dev/terraform.tfstate"
    region       = "YOUR_AWS_REGION"
    encrypt      = true
    use_lockfile = true
  }
}
```

Staging uses a separate key:

```hcl
key = "environments/staging/terraform.tfstate"
```

Both environments share the same bucket but never share the same state file.

### 3. Reusable Terraform Modules

Infrastructure is defined once and reused across environments.

Each environment can have its own:

- CIDR ranges.
- Instance types.
- Resource names.
- Environment-specific tags.
- Input variables.

This keeps infrastructure consistent while allowing environment-specific customization.

## Getting Started

### Prerequisites

Make sure you have:

- Terraform CLI installed.
- An AWS account.
- AWS CLI configured with appropriate credentials.
- IAM permissions to provision the required AWS resources.
- Access to the project repository.

Verify your installations:

```bash
terraform version
aws --version
aws sts get-caller-identity
```

## Deployment Workflow

### Step 1: Bootstrap the S3 Backend

The S3 bucket must exist before application environments can use it as a remote backend.

Navigate to the bootstrap directory:

```bash
cd bootstrap
```

Initialize Terraform:

```bash
terraform init
```

Review and provision the backend infrastructure:

```bash
terraform plan
terraform apply
```

The bootstrap root initially uses local state. Keep its state securely backed up, because it manages the bucket that stores the application roots' state.

**Important:** The bootstrap infrastructure must be managed independently. Application cleanup must never destroy the shared backend bucket.

### Step 2: Initialize Development Environment

Navigate to the development root:

```bash
cd environments/dev
```

Initialize Terraform:

```bash
terraform init
```

Review the proposed infrastructure changes:

```bash
terraform plan
```

Deploy:

```bash
terraform apply
```

### Step 3: Deploy Staging Environment

Navigate to staging:

```bash
cd ../staging
```

Initialize and review:

```bash
terraform init
terraform plan
```

Deploy staging:

```bash
terraform apply
```

Review the provisioned infrastructure, validate the configurations, and verify that staging operates independently of development.

After completing the review, remove temporary staging infrastructure:

```bash
terraform destroy
```

Destroying staging does not remove development resources or the shared S3 backend.

## Migrating Existing Local State

If infrastructure was previously managed using local state, migrate it to S3 instead of recreating the resources.

First, back up the existing state:

```bash
cp terraform.tfstate terraform.tfstate.backup
```

Configure the S3 backend and run:

```bash
terraform init -migrate-state
```

Terraform will migrate the existing state to the configured S3 backend.

Verify the migrated resources:

```bash
terraform state list
```

Then check for unexpected infrastructure changes:

```bash
terraform plan
```

The expected result is:

```text
No changes. Your infrastructure matches the configuration.
```

### `-migrate-state` vs `-reconfigure`

| Command | Purpose |
|---|---|
| `terraform init -migrate-state` | Moves existing state to the newly configured backend. |
| `terraform init -reconfigure` | Initializes using new backend settings without migrating the previous state. |

Use migration when moving existing infrastructure management to S3. Use reconfiguration when intentionally changing backend initialization settings without transferring the old state.

## Security and State Management

Terraform state may contain sensitive infrastructure information, so it must be treated as confidential data.

The following practices are followed:

- Keep the state bucket private.
- Enable encryption and versioning.
- Enforce HTTPS-only access.
- Apply least-privilege IAM permissions.
- Restrict access to state and lock objects.
- Securely back up bootstrap state.
- Never commit state files, credentials, or sensitive `.tfvars` files to Git.
- Avoid destroying the bootstrap infrastructure during application cleanup.

For native S3 locking, the required permissions include:

| S3 Permission | Purpose |
|---|---|
| `s3:ListBucket` | List relevant bucket objects. |
| `s3:GetObject` | Read state and lock objects. |
| `s3:PutObject` | Write state and acquire locks. |
| `s3:DeleteObject` | Release locks. |

Permissions should be scoped to the appropriate environment paths. State objects and lock objects require different access considerations.

## Important Design Decisions

1. **Separate bootstrap root:** Prevents the application infrastructure from depending on a backend it is responsible for creating.
2. **Independent environment roots:** Keeps development and staging state isolated.
3. **Shared modules:** Reduces duplication and maintains consistent infrastructure configurations.
4. **Native S3 locking:** Avoids the need for a separate DynamoDB locking table.
5. **Independent cleanup:** Allows temporary environments to be destroyed without affecting persistent infrastructure or shared backend resources.

## Cleanup

To remove development infrastructure:

```bash
cd environments/dev
terraform destroy
```

To remove staging infrastructure:

```bash
cd environments/staging
terraform destroy
```

The bootstrap root and S3 backend should remain intact unless you are intentionally decommissioning the entire Terraform setup.

---

**The core principle:** Application infrastructure should be replaceable, environment states should remain isolated, and the shared Terraform backend should be protected independently from application lifecycle operations.