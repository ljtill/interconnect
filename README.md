# Interconnect

The idea behind this project is to provide the base network foundations to interconnect multiple cloud providers. Each provider has a predefined network topology and is peered with another provider through VPN's. The VPN's are configured with Route Propagation (BGP) which provides each cloud vendor the ability to dynamically learn new subnets.

| Provider              | Address Prefix |
| --------------------- | -------------- |
| Amazon Web Services   | 172.24.0.0/16  |
| Microsoft Azure       | 172.25.0.0/16  |
| Google Cloud Platform | 172.26.0.0/16  |

_Please note this repository is under development and subject to change._

## Getting Started

1. Update the `src/main.tf` file with your Terraform Cloud organization and workspace information.

2. Within Terraform Cloud, add the following variables to your workspace

- ARM_TENANT_ID
- ARM_SUBSCRIPTION_ID
- ARM_CLIENT_ID
- ARM_CLIENT_SECRET
- AWS_ACCESS_KEY
- AWS_SECRET_KEY
