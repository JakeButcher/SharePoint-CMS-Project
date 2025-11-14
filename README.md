# SharePoint CMS Automated Deployment

## Overview
This project demonstrates the use of **Terraform**, **PowerShell**, and **(future) Python scripts** to automatically deploy Azure infrastructure and configure a SharePoint farm.  

The goal is to standardise, automate, and accelerate SharePoint deployments by using Infrastructure-as-Code (IaC) and scripted configuration. Although the scripts here are boilerplates and variables have been sanitised, they outline a full deployment workflow that can be adapted for different environments.

These automation steps ensure consistent configuration, faster provisioning, and improved adherence to best practices—particularly around SharePoint and administrative account setup.

---

## Project Directory Structure

```text
│
├── .github
│ ├── ci.yml
│
├── docs
│ ├── architecture.md
│ ├── prerequisites.md
│ ├── troubleshooting.md
│
├── dsc
│ ├── sharepoint_dsc.ps1
│
├── scripts
│ ├── PS Config Scripts
│ │ ├── Admin and Maintenance
│ │ │ ├── Backup SP Farm.ps1
│ │ │ ├── Check Services.ps1
│ │ ├── Deployment
│ │ │ ├── 01 DC Setup.ps1
│ │ │ ├── 02 Install SQL.ps1
│ │ │ ├── 03 Install SharePoint Prereqs.ps1
│ │ │ ├── 04 Install SharePoint.ps1
│ │ │ ├── Create SP Farm.ps1
│ │ │ ├── Create Service Apps.ps1
│ │ │ ├── Start Services.ps1
│ │ ├── Post Deployment
│ │ │ ├── Create Webapp.ps1
│ ├── Provisioning Infra Scripts
│ │ ├── Terraform
│ │ │ ├── main.tf
│ │ │ ├── providers.tf
│ │ │ ├── terraform.tfvars
│ │ │ ├── variables.tf
│ │ ├── Python (TODO)
│
└── README.md
```

---

## Architecture Diagram  
**TODO:** Add diagram inline (planned).

---

## Cloud Provider
This project deploys infrastructure into **Microsoft Azure**.

---

## Components

### **Terraform**
**Deployment includes:**
- Resource Group  
- Azure Virtual Network
- Subnet  
- Network Security Group (allowing RDP/3389 with priority 1001)  
- Network Interface  
- Virtual Machine(s)

**Variables used:**
- `resource_group_name`
- `location`
- `admin_username`
- `admin_password`

---

### **PowerShell**

#### **Deployment**
- Configure Domain Controller with correct roles
- Install SQL Server and provision SharePoint admin accounts
- Install SharePoint prerequisites
- Install SharePoint 2019
- Create the SharePoint farm
- Create required Service Applications
- Start required SharePoint services

#### **Post-Deployment**
- Create SharePoint Web Application

#### **Admin & Maintenance**
- Full farm backup
- Check current SharePoint service status

---

### **DSC**
**TODO** – Add configuration enforcement modules.

---

### **CI/CD**
**TODO** – Document GitHub Actions workflow (`ci.yml`).

---

## End-to-End Automation Flow

1. Configure variables in `variables.tf`.
2. Run **Terraform Plan** and review the output.
3. Run **Terraform Apply** to provision Azure infrastructure.
4. Connect to the deployed VMs  
   - Preferably through **Azure Bastion**  
   - Otherwise via a public IP (if enabled)
5. Run the PowerShell deployment scripts sequentially.  
   - Multi-server farms require scripts to be run on the appropriate DC, SQL, and SharePoint nodes.
6. Perform smoke tests to validate configuration and ensure farm health.

---

## Skills Demonstrated
- **Infrastructure-as-Code (IaC)** using Terraform  
- **Cloud deployment** on Azure  
- **Environment provisioning & configuration automation** using PowerShell  
- **CI/CD practices** using GitHub (pipeline in progress)  
- **SharePoint 2019 farm deployment and administration**

---

## Notes
- All variables have been sanitised.
- Scripts are boilerplates and may require modification before real-world use.
- Python components and architectural assets will be added later.
