# 🚀 Selena Infrastructure (AWS + Terraform)

![AWS](https://img.shields.io/badge/AWS-Cloud-orange)
![Terraform](https://img.shields.io/badge/Terraform-IaC-purple)
<!--![Status](https://img.shields.io/badge/status-active-success)-->

---

## 📌 Overview

This repository defines the **AWS Cloud Infrastructure** required to run the selena microservice platform in a scalable and production-ready environment using Terraform

The platform consists of two core services:

- `users-service`
- `hotels-service`
<!--The system is designed with a focus on:

scalability
isolation between services
secure secret management
production-like infrastructure patterns

It handles domain entities such as users, hotels, and locations, and supports horizontal scaling under load.-->
---

## 🚀 Key Characteristics

- Scalable architecture using Auto Scaling Groups (1 → 3 instances)
- Secure secret management via AWS Secrets Manager
- Isolated service-to-database communication
- Public and internal traffic separation via ALBs
- Docker-based deployment with Amazon ECR
- Custom NAT instance for outbound internet access
- Infrastructure is modular and reusable
    
<!-- 🧠 Design Focus

The infrastructure is built with an emphasis on:

- **Scalability** — automatic horizontal scaling under load  
- **Isolation** — each service owns its database  
- **Security** — secrets and certificates managed centrally  
- **Reliability** — health checks and fault isolation  -->
---

## 🏗️ Architecture

```text
                                    Internet
                                        │
                              ┌─────────▼─────────┐
                              │    Public ALB     │
                              └─────────┬─────────┘
                                        │
            ┌───────────────────────────┴───────────────────────────┐
            │                                                       │
            │                                                       │
            │              ┌───────────────────────┐                │
    ┌───────▼────────┐     │     Internal ALB      │     ┌──────────▼────────┐
    │ users-service  │◄───►│      (private)        │◄───►│ hotels-service    │
    │     (ASG EC2)  │     └───────────────────────┘     │      (ASG EC2)    │
    │                │                                   │                   │
    │  Private Subnet│◄────┌───────────────────────┐────►│  Private Subnet   │
    └──┬─────────────┘     │       Bastion         │     └────────────────┬──┘
       │          ▲        │   (SSH connetion)     │        ▲             │
       │          │        └───────────────────────┘        │             │
       │          │                           │             │             │
       │          ▼                           ▼             ▼             │
       │       ┌───────────────────┐       ┌───────────────────┐          │
       │       │       RDS         │       │    CockroachDB    │          │
       │       │    (private)      │       │   (EC2, private)  │          │
       │       └───────────────────┘       └───────────────────┘          │
       │                                                                  │
       │                                                                  │
       │                    ┌───────────────────────┐                     │
       └───────────────────►│     NAT Instance      │◄────────────────────┘
                            │    (public subnet)    │
                            └───────────┬───────────┘
                                        │
                                     Internet
```

---

## ☁️ Infrastructure Components

### 🌐 Networking

- Custom VPC <!--(`10.0.0.0/16`)-->
- Public and private subnets across 2 Availability Zones:
    - `eu-central-1a`
    - `eu-central-1b`
- Internet Gateway for public access
- Custom NAT Instance (not NAT Gateway)

#### Route tables

- Public subnets → Internet Gateway (`0.0.0.0/0`)
- Private subnets → NAT Instance (`0.0.0.0/0`)

<!--- Route tables:
    -- Public → Internet Gateway  (`0.0.0.0/0`)
    -- Private → NAT Instance  (`0.0.0.0/0`)-->
<br><br>

### 💻 Compute

- EC2 instances managed via Auto Scaling Groups

#### Scaling configuration

- min: `1`
- max: `3`
<!--- Each service:
    -- min: 1 instance
    -- max: 3 instances
- Instances use a custom AMI built with Packer-->

<br><br>

### ⚖️ Load Balancing

#### Public ALB
Routes external traffic:

 - `users-service.selena-aws.com`
 - `hotels-service.selena-aws.com`

#### Internal ALB
Used for service-to-service communication inside VPC:

 - `users.internal.selena`
 - `hotels.internal.selena`

<br><br>

### 🌐 DNS & TLS

#### Route53
 - Public hosted zone: `selena-aws.com`
 - Private hosted zone: `internal.selena`

#### ACM (AWS Certificate Manager)
 - Wildcard certificate: `*.selena-aws.com`
 - DNS validation

<br><br>

### 📦 Containerization

 - Services are packaged as Docker containers
 - Images stored in Amazon ECR

#### EC2 bootstrap

- Authenticate to ECR
- Pull images on startup via UserData scripts

<br><br>

### 🔐 Secrets Management

- AWS Secrets Manager

 #### Data:

- Database credentials
- Service configuration

<br><br>

### ⚙️ Service Bootstrap (UserData)

Each EC2 instance:
1. Installs Docker
2. Authenticates to ECR
3. Fetches secrets from Secrets Manager
4. Pulls latest Docker image
5. Starts container

---

## 📦 AMI (Packer)

Custom base AMI is built using Packer:

### Path

```bash
infrastructure/terraform/packer/templates/selena-base-ami.pkr.hcl
```

### Includes

 - Amazon Linux 2023
 - Docker
 - Git
 - CloudWatch Agent

### Build

```bash
cd infrastructure/terraform

SUBNET_ID=$(terraform -chdir=environments/dev output -json public_subnet_ids | jq -r '.[0]')

packer build -var "subnet_id=$SUBNET_ID" packer/templates/selena-base-ami.pkr.hcl
```

---

## 🚀 Deployment

###  Terraform

Go to the working directory:

```bash
cd infrastructure/terraform/environments/dev
```

Initialize:

```bash
terraform init
```

Apply:

```bash
terraform apply
```

---

## ⚙️ Configuration

### Example variables (terraform.tfvars):

```hcl
Region: eu-central-1
Environment: prod
Instance type: t3.nano
VPC CIDR: 10.0.0.0/16
```

### Feature flags:

```hcl
enable_users_alb  = true
enable_users_db   = true

enable_hotels_alb = true
enable_hotels_db  = true

enable_bastion    = true
```

---

## 🔐 IAM & Security

Each service has dedicated IAM roles:

### users-service

 - Access to:
    - ECR
    - Secrets Manager
    - RDS

### hotels-service

 - Access to:
    - ECR
    - Secrets Manager
    - SSM (CockroachDB certificates)
    <!--- Packer role (AMI build)
    - CockroachDB EC2 role-->

---

## 🌐 DNS

### Public endpoints:

 - users-service.selena-aws.com
 - hotels-service.selena-aws.com

### Internal endpoints:

 - users.internal.selena
 - hotels.internal.selena
 - hotels_db.internal.selena

---

## 🧱 Project Structure

    infrastructure/terraform/
        ├── packer/
        │   ├── templates/
        │   └── scripts/
        │
        ├── scripts/
        │
        ├── environments/
        │   └── dev/
        │       ├── root.tf
        │       ├── root_iam.tf
        │       ├── route53.tf
        │       ├── acm_shared.tf
        │       │
        │       ├── users/
        │       │   ├── users.tf
        │       │   ├── iam_users.tf
        │       │
        │       ├── hotels/
        │       │   ├── hotels.tf
        │       │   └── iam_hotels.tf
        │       │
        │       └── s3_files/
        │           └── users.env.cloud
        │
        └── modules/
            ├── alb_internal/
            ├── alb_shared/
            ├── alb_service/
            ├── asg/
            ├── ec2/
            ├── ec2_db/
            ├── ecr/
            ├── iam/
            │   ├── iam-policies/
            │   │   ├── users/
            │   │   └── hotels/
            │   └── iam-roles/
            │
            ├── rds/
            ├── s3/
            ├── sns/
            └── vpc/
            ├── networking/
            │   ├── nat-instance/
            │   ├── routing/
            │   ├── security_group/
            │   ├── vpc/

---

## 📊 Health Checks

Application Load Balancers perform health checks on both services, maintaining their availability

---

## ⚠️ Notes

 - This project is designed with production-like patterns:
    - modular Terraform structure
    - separation of concerns
    - infrastructure as code
 - NAT Gateway is intentionally replaced with a custom NAT instance
 - CockroachDB is self-managed on EC2

---

## 📈 Future Improvements

 - Add CloudWatch metrics & alarms
 - Add centralized logging and tracing
 - Migrate to EKS
 - Redesign the CI/CD pipeline to use OIDC
<!--👨‍💻 Author

Developed as part of Cloud Engineering learning path.-->