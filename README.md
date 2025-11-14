# READ ME

## Important Info
The purpose is to demonstrate the use of PowerShell, Terraform and Python scripts for automatically deploying infrastructure and SharePoint configurations.
- All variables have been sanitised
- Scripts given are simple boilerplates and would need to be reviewed and amended
- For documentation purposes only

## Directory Overview

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
│   │   │   ├── terraform.tfstate
│   │   │   ├── terraform.tfstate.backup
│   │   │   ├── terraform.tfvars
│   │   │   ├── variables.tf
│   │   ├── Python
│
└── README.md  ← General Info
