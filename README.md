# AWS AppStream Terraform Configuration

This project contains Terraform configuration files for setting up a basic AWS infrastructure for an AppStream deployment. It includes a Virtual Private Cloud (VPC), subnets, security groups, EC2 instances, and AWS AppStream resources such as fleets, stacks, and user associations.

## Prerequisites

Before using this configuration, make sure you have the following:

- [Terraform](https://www.terraform.io/downloads.html) installed on your machine
- An [AWS Account](https://aws.amazon.com/)
- AWS CLI configured with appropriate credentials:
  ```bash
  aws configure
  ```
## Resources Created
This Terraform configuration will provision the following resources:

### 1. VPC and Subnet:
a. A Virtual Private Cloud (VPC) with CIDR block 10.0.0.0/16.
b. A subnet inside the VPC with CIDR block 10.0.0.0/24.
### 2. Security Group:

a. A security group that allows HTTPS (port 443) ingress and all outbound traffic.
### 3. EC2 Instance:

a. An EC2 instance (t3.medium) using a specific AMI, deployed in the subnet and secured by the security group.
### 4. AWS AppStream Fleet and Stack:

a. An AppStream fleet with one ON_DEMAND instance of type stream.standard.medium.
b. A stack allowing various user actions such as clipboard copy, file uploads/downloads, and printing to local devices.
### 5. AWS AppStream User and Associations:

a. A user with USERPOOL authentication is created and associated with the AppStream stack.
### 6. Image Builder:

a. An AppStream image builder is set up to customize images.
## Usage
1. Clone the repository to your local machine:

```bash
git clone <your-repo-url>
cd <your-repo-directory>
```
2. Initialize the Terraform workspace:

```bash
terraform init
```
3. Preview the changes that will be applied:

```bash
terraform plan
```
4. Apply the Terraform configuration to create the resources:

```bash
terraform apply
```
5. When finished, you can destroy the resources using:

```bash
terraform destroy
```
## Notes
A. The AppStream fleet uses the default image AppStream-WinServer2019-10-05-2022. You can customize this in the aws_appstream_fleet resource.
B. The user created in the aws_appstream_user resource is currently set to iniemem@clessence.com. Please update this to your own user information if required.
## Security
A. Ensure that any sensitive information, such as email addresses or keys, is kept secure.
B. The SSH key pair name (test-appstream) used for EC2 instances should be available in your AWS account. If not, modify it as needed.
