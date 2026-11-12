# Nova Retail – AWS Infrastructure Automation

## Project Overview

Nova Retail is a cloud infrastructure automation project focused on designing and defining a secure, scalable, and cost-conscious AWS environment using Infrastructure as Code (IaC).

The project demonstrates a multi-Availability Zone network architecture for a fictional retail organisation, using Terraform to define AWS networking, compute, load balancing, and database resources.

The infrastructure is designed to demonstrate network isolation, controlled application access, private database connectivity, and infrastructure automation.

## Architecture

The architecture uses an Amazon Virtual Private Cloud (VPC) with public and private subnets distributed across two Availability Zones in the AWS Africa (Cape Town) region (`af-south-1`).

### Architecture Components

| AWS Service | Purpose |
|---|---|
| Amazon VPC | Provides an isolated cloud network |
| Public Subnets | Host internet-facing infrastructure |
| Private Subnets | Host application and database resources |
| Internet Gateway | Provides internet connectivity to public subnets |
| Application Load Balancer | Distributes incoming application traffic |
| Amazon EC2 | Hosts the demonstration application |
| Auto Scaling Group | Manages application instance capacity |
| Amazon RDS for MySQL | Provides a managed relational database |
| S3 Gateway VPC Endpoint | Provides private network access to Amazon S3 |
| Security Groups | Control inbound and outbound network traffic |

**Note:** An S3 bucket is not provisioned as part of the current Terraform configuration. The S3 Gateway Endpoint establishes a private network path to the S3 service; application permissions and bucket configuration would need to be implemented separately.

## Network Design

- VPC CIDR: `10.20.0.0/16`
- AWS Region: `af-south-1`
- Two Availability Zones
- Two public subnets
- Two private subnets
- Internet Gateway for public subnet connectivity
- Separate public and private route tables
- S3 Gateway VPC Endpoint associated with the private route table

Private application and database resources are not directly exposed to the public internet.

The public subnets provide connectivity for the internet-facing Application Load Balancer, while application and database resources are placed in private subnets.

## Security Considerations

The architecture incorporates network segmentation and controlled access through:

- Public and private subnet separation.
- Security Groups restricting traffic between infrastructure components.
- EC2 instances deployed in private subnets.
- RDS configured with public accessibility disabled.
- MySQL access restricted to the application EC2 Security Group.
- Application HTTP access restricted to traffic originating from the ALB Security Group.
- IMDSv2 enforced on EC2 instances.
- Encryption enabled for the EC2 root EBS volume and RDS storage.

The ALB currently accepts HTTP traffic on port 80. HTTPS and TLS termination are future enhancements for a production-ready implementation.

## Cost Optimisation

Cost control is an important consideration in the project design.

The initial architecture intentionally excludes a NAT Gateway to avoid its recurring hourly and data-processing charges.

Other cost-conscious design decisions include:

- Single-AZ RDS deployment.
- Small EC2 instance sizing.
- A single desired EC2 instance initially.
- A maximum Auto Scaling Group capacity of two instances.
- No custom domain or paid certificate requirement for the initial demonstration.
- S3 Gateway Endpoint instead of a NAT Gateway for supported S3 traffic.

Private EC2 instances do not have general outbound internet connectivity in the current design.

AWS resources may still incur charges, including the Application Load Balancer, EC2 instances, EBS volumes, RDS, public IPv4 addresses, and data transfer.

## Infrastructure as Code

Terraform is used to define the AWS infrastructure.

The configuration is organised into separate files to improve maintainability and make the infrastructure easier to understand:

- `main.tf` – VPC, subnets, routing, endpoint, and Security Groups.
- `compute.tf` – EC2 Launch Template.
- `scaling.tf` – Auto Scaling Group.
- `loadbalancer.tf` – Application Load Balancer and target group.
- `database.tf` – RDS DB subnet group.
- `rds.tf` – MySQL database instance.
- `variables.tf` – Input variables.
- `outputs.tf` – Infrastructure outputs.
- `providers.tf` – AWS provider configuration.
- `versions.tf` – Terraform and provider version constraints.

GitHub is used for source control and project documentation.

GitHub Actions automates Terraform formatting checks, initialization, and configuration validation when relevant changes are pushed to the repository.

## Project Status

**Current phase:** Terraform configuration and automated validation completed.

Completed:
- Architecture design and documentation.
- VPC and subnet configuration.
- Public and private routing.
- Security Group configuration.
- EC2 Launch Template.
- Auto Scaling Group configuration.
- Application Load Balancer configuration.
- RDS MySQL configuration.
- S3 Gateway VPC Endpoint.
- Terraform formatting and validation.
- GitHub Actions validation workflow.

Outstanding:
- AWS resource provisioning.
- Deployment and connectivity testing.
- Application-to-database integration.
- Infrastructure and security validation.
- Deployment and operational documentation.

**Important:** The Terraform configuration has been validated, but the AWS infrastructure has not yet been deployed.

## Architecture Diagram

[Nova Retail AWS Architecture](https://github.com/corettakingsley/aws-infrastructure-automation/blob/main/architecture/nova-retail-architecture.png)

[View or download the architecture image](https://github.com/corettakingsley/aws-infrastructure-automation/raw/main/architecture/nova-retail-architecture.png)

## Network Traffic Flow

The Nova Retail architecture uses controlled traffic flows to protect application and database resources.

### 1. Incoming Application Traffic

1. External users access the application over HTTP.
2. Traffic reaches the Application Load Balancer through the Internet Gateway.
3. The ALB forwards requests to healthy EC2 instances in the private application subnets.

### 2. Application Processing

1. EC2 instances receive application requests from the ALB.
2. The current demonstration application serves a static HTML page.
3. The infrastructure includes a private MySQL database, with network access restricted to the EC2 Security Group.
4. Application-to-database integration is a planned enhancement.

### 3. Database Communication

- Amazon RDS for MySQL is configured in private subnets.
- The DB subnet group spans two Availability Zones.
- The database itself uses a Single-AZ deployment.
- Public accessibility is disabled.
- Inbound MySQL traffic on port 3306 is restricted to the EC2 Security Group.

### 4. Amazon S3 Communication

The S3 Gateway VPC Endpoint provides a private network route for supported S3 traffic from the private route table.

This allows eligible S3 communication without requiring a public internet route or NAT Gateway.

An S3 bucket and the necessary IAM permissions would need to be configured separately before an application could use this functionality.

### 5. Internet Connectivity Considerations

The initial architecture does not include a NAT Gateway.

Consequently, EC2 instances in private subnets do not have general outbound internet access. This is an intentional cost-saving decision.

If outbound internet connectivity or additional AWS service integrations become necessary, a NAT Gateway, VPC endpoints, or another suitable egress solution can be introduced depending on the requirements.
