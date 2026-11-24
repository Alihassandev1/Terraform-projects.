# Phase 3 - Modular EC2 and Docker Deployment

Phase 3 introduces reusable Terraform modules while keeping the application design focused on EC2 instances. It includes remote state bootstrap, a modular network, Docker-based application deployment, IAM/SSM access, and S3 storage.

## What I Built

### Remote State

- A separate `bootstrap` root creates the S3 state bucket.
- The bucket uses versioning, encryption, public-access blocking, and an HTTPS-only policy.
- The development environment uses S3 as a remote backend with native state locking.

### Network Module

- VPC and public subnet.
- Internet gateway.
- Public route table and route-table association.
- EC2 security group.
- Configurable VPC, subnet, and subnet maps.

### Compute Module

- Primary EC2 instance.
- A loop-created set of three additional EC2 instances.
- Ubuntu instance startup using `cloud-init` and a template file.
- Docker installation and startup through the EC2 user data.
- Docker image pull and container launch.
- Configurable environment, instance type, Docker image, container name, subnet, security group, and IAM instance profile.
- Encrypted GP3 root storage on the primary instance.

### IAM Module

- EC2 trust role.
- `AmazonSSMManagedInstanceCore` policy attachment.
- EC2 instance profile for SSM access.

### Storage Module

- Versioned S3 application bucket.

## Project Layout

```text
phase-3.0/
├── bootstrap/
├── environments/dev/
└── modules/
    ├── network/
    ├── compute/
    ├── roles/
    └── storage/
```

The development root connects each module through Terraform outputs and inputs.

## Docker Startup

The `fastapi.sh.tftpl` template:

1. Updates Ubuntu packages.
2. Installs Docker.
3. Enables and starts Docker.
4. Pulls the configured container image.
5. Runs the container on port 80.

## Deployment

Create the backend first:

```powershell
cd .\bootstrap
terraform init
terraform validate
terraform apply
```

Deploy the development environment:

```powershell
cd ..\environments\dev
terraform init
terraform validate
terraform plan
terraform apply
```

The instance IDs and public IPs are exposed through module outputs.

## Cleanup

```powershell
cd .\environments\dev
terraform destroy
```
