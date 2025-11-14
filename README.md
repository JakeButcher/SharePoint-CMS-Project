# READ ME
## Overview



<details>
  <summary><strong>Project Directory Structure</strong></summary>

```text
│
├── .github
│   ├── ci.yml
│
├── docs
│   ├── architecture.md
│   ├── prerequisites.md
│   ├── troubleshooting.md
│
├── dsc
│   ├── sharepoint_dsc.ps1
│
├── scripts
│   ├── PS Config Scripts
│   │   ├── Admin and Maintenance
│   │   │   ├── Backup SP Farm.ps1
│   │   │   ├── Check Services.ps1
│   │   ├── Deployment
│   │   │   ├── 01 DC Setup.ps1
│   │   │   ├── 02 Install SQL.ps1
│   │   │   ├── 03 Install SharePoint Prereqs.ps1
│   │   │   ├── 04 Install SharePoint.ps1
│   │   │   ├── Create SP Farm.ps1
│   │   │   ├── Create Service Apps.ps1
│   │   │   ├── Start Services.ps1
│   │   ├── Post Deployment
│   │   │   ├── Create Webapp.ps1
│   ├── Provisioning Infra Scripts
│   │   ├── Terraform
│   │   │   ├── main.tf
│   │   │   ├── providers.tf
│   │   │   ├── terraform.tfvars
│   │   │   ├── variables.tf
│   │   ├── Python
│
└── README.md  ← General Info
```
</details>

Describe what the project automates and why.

The purpose is to demonstrate the use of PowerShell, Terraform and Python scripts for automatically deploying infrastructure and SharePoint configurations.
- All variables have been sanitised
- Scripts given are simple boilerplates and would need to be reviewed and amended
- For documentation purposes only

These scripts help standardise and automate the deployment process of SharePoint farms. By using IaC and PowerShell the speed and consistency of deployments is improved and can be easily reconfigured for different purposes, such as different environments. This specifically helps with SharePoint account configuration as best practise for administrative accounts can be ensured when provisioning software.



## Architecture Diagram

Todo: Include the diagram inline.



## Cloud Provider

This configuration specifically uses Azure.



## Components

<details>
<summary><strong>Terraform:</strong></summary>
  
Deployment:
- Creates Resource Group.
- Creates Azure VNET.
    Internal Address space 10.0.0.0/16
- Creates Azure SubNET.
- Creates Network Securtiy Group.
    Allows 3389/RDP with priority 1001
- Creates Network Interface Card.
- Creates VM(s)

Variables:
- variable "resource_group_name".
- variable "location".
- variable "admin_username".
- variable "admin_password".
</details>

<details>
<summary><strong>PowerShell:</strong></summary>

Deployment:
- Setup DC Farm with correct minrole and configuration.
- Install SQL and provision admin accounts.
- Install SharePoint Prerequisites.
- Install SharePoint 2019.
- Create the SharePoint Farm.
- Create Service Applications.
- Start SharePoint Services.

Post Deployment:
- Create Webapp.
  
Admin and Maintenance:
- Take a full backup of the SharePoint Farm.
- Check what SharePoint services are currently running.
</details>

<details>
<summary><strong>DSC:</strong></summary>
Todo
</details>

<details>
<summary><strong>CI/CD:</strong></summary>
Todo
</details>



## End-to-End Automation Flow
1. Configure variables.tf
2. Run Terraform Plan and confirm infrastructure to be deployed.
3. Run Terraform Apply to begin provisioning in Azure.
4. Connect to Azure VMs. (Ideally via Azure Bastion, otherwise a public IP will need to be configured)
5. Run the PowerShell Deployment scripts sequentually. (If provisioning a multiserver farm, run DC, SP and SQL scripts on seperate servers)
6. Confirm configuration by performing smoke tests.



## Skills Demonstrated

- Provisioning IaC using Terraform
- Followijng CI/CD practises using GitHub
- Provisioning, Configuring and Maintaining environments with PowerShell

