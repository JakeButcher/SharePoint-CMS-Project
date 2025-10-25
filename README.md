# SharePoint-CMS-Project
CMS Project to show skills with: Azure IaaS, Windows Server, Terraform, SharePoint, GitHub

# Repository Overview
- / (root)
- ├─ README.md                    # Overview, prerequisites, and run instructions
- ├─ LICENSE.md
- ├─ docs/
- │ ├─ architecture.md            # CMS architecture, accounts, network & ports
- │ ├─ prerequisites.md           # OS, SQL, SharePoint, and Azure requirements
- │ └─ troubleshooting.md         # Common deployment issues and fixes
- ├─ terraform/                   # Terraform templates to deploy Azure infrastructure
- │ ├─ main.tf                    # Main Terraform config (VM, network, NSG, storage)
- │ ├─ variables.tf               # Variable definitions for Azure resources
- │ ├─ outputs.tf                 # Outputs for VM name, IP, etc.
- │ └─ terraform.tfvars.example   # Example values for customization
- ├─ scripts/                     # PowerShell scripts for configuration
- │ ├─ 01-install-sql.ps1         # Install SQL Server silently
- │ ├─ 02-install-prereqs.ps1     # Install SharePoint prerequisites & OS features
- │ ├─ 03-install-sharepoint.ps1  # Install SharePoint 2019 binaries
- │ ├─ 04-config-farm.ps1         # Configure SharePoint farm (single server)
- │ ├─ 05-create-site.ps1         # Create CMS site collection & sample content
- │ └─ helpers/                   # Utility functions for logging and credential mgmt
- │ └─ utils.psm1
- ├─ dsc/                         # Desired State Configuration scripts for idempotency
- │ ├─ sharepoint_dsc.ps1
- │ └─ modules/
- ├─ assets/
- │ └─ diagrams/                  # PNG/SVG topology diagrams
- ├─ .github/
- │ └─ workflows/
- │ └─ ci.yml                     # GitHub Action to validate Terraform & PowerShell scripts
- └─ examples/
- └─ params.example.json          # Example parameters and secrets structure (placeholders only)
