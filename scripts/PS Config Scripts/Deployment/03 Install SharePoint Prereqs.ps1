<#
.SYNOPSIS
Installs all Windows and SharePoint 2019 prerequisites.

.DESCRIPTION
This script prepares a Windows Server 2019/2022 machine for SharePoint 2019 installation.
It installs required Windows features and runs the SharePoint 2019 prerequisite installer silently.

.PARAMETER SPInstallPath
Local path or network share containing SharePoint 2019 installation files.
#>

param(
    [Parameter(Mandatory = $true)]
    [string]$SPInstallPath
)

$LogPath = "C:\SP2019InstallLogs"
New-Item -ItemType Directory -Path $LogPath -Force | Out-Null

Write-Host "`n=== Installing Windows Server prerequisites for SharePoint 2019 ===" -ForegroundColor Cyan

# Step 1: Windows Server Features
Install-WindowsFeature Web-Server, Web-WebServer, Web-Common-Http, Web-Static-Content, Web-Default-Doc, `
Web-Dir-Browsing, Web-Http-Errors, Web-App-Dev, Web-Asp-Net45, Web-Net-Ext45, Web-ISAPI-Ext, Web-ISAPI-Filter, `
Web-Health, Web-Http-Logging, Web-Log-Libraries, Web-Request-Monitor, Web-Http-Tracing, Web-Security, `
Web-Basic-Auth, Web-Windows-Auth, Web-Filtering, Web-Performance, Web-Stat-Compression, Web-Dyn-Compression, `
Web-Mgmt-Tools, Web-Mgmt-Console, Web-Mgmt-Compat, Web-Metabase, NET-Framework-Features, NET-Framework-Core, `
NET-Framework-45-Core, NET-WCF-HTTP-Activation45, Server-Media-Foundation, Windows-Identity-Foundation `
 -IncludeAllSubFeature -IncludeManagementTools -ErrorAction SilentlyContinue | Out-Null

Write-Host "✅ Windows roles and features installed." -ForegroundColor Green

# Step 2: SharePoint Prerequisites
Write-Host "`nInstalling SharePoint 2019 prerequisites..." -ForegroundColor Cyan

$PrereqInstaller = Join-Path $SPInstallPath "prerequisiteinstaller.exe"
if (!(Test-Path $PrereqInstaller)) {
    Write-Error "Cannot find prerequisiteinstaller.exe in $SPInstallPath. Please check your installation media."
    exit 1
}

Start-Process -FilePath $PrereqInstaller -ArgumentList "/unattended",
    "/SQLNCli:", "https://go.microsoft.com/fwlink/?LinkID=799013",
    "/IDFX:", "https://download.microsoft.com/download/9/3/F/93F1AA10-005A-43B0-9B0D-1DB744BFA4D9/Windows6.1-KB974405-x64.msu",
    "/Sync:", "https://download.microsoft.com/download/F/7/2/F726F9E4-EDB0-497F-A3E9-3A1A6900E8C2/MicrosoftSyncFrameworkRuntime-v1.0-x64-ENU.msi",
    "/AppFabric:", "https://download.microsoft.com/download/1/6/3/163A76E6-55E1-4E06-9B65-60F59C1EDE86/W2K12-KB3092423-x64.msu",
    "/MSIPCClient:", "https://download.microsoft.com/download/8/E/6/8E6C3B4A-25E4-4C7D-8DBA-BAB4A4D8FA1C/setup_msipc_x64.exe",
    "/WCFDataServices:", "https://download.microsoft.com/download/0/1/3/013AC8E5-7D0A-4CF1-ACCE-B36B7A50AE59/WcfDataServices.exe",
    "/ODBC:", "https://download.microsoft.com/download/2/2/1/2215A3E4-AE3C-4A6C-B1E1-066B8F56C3A0/msodbcsql.msi" `
 -Wait -PassThru | Out-File "$LogPath\PrereqInstaller.log" -Append

Write-Host "`n✅ SharePoint 2019 prerequisites installed successfully." -ForegroundColor Green
Write-Host "`n=== Prerequisite installation complete ===" -ForegroundColor Cyan