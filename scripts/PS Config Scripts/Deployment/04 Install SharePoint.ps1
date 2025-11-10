<#
.SYNOPSIS
Installs and configures SharePoint Server 2019 on a single-server farm.

.DESCRIPTION
This script installs SharePoint 2019 prerequisites, binaries, and configures
a single-server farm connected to an existing SQL Server instance.

.PARAMETER SPInstallPath
Local path or network share containing SharePoint 2019 installation files (.exe or extracted ISO)

.PARAMETER SPSetupUser
Domain account used for installation (must be farm admin & local admin)

.PARAMETER SPSvcAccount
Service account for SharePoint services and app pool identities

.PARAMETER SQLServer
SQL Server name or instance hosting SharePoint databases

.PARAMETER FarmPassphrase
Farm passphrase used for configuration and future joins

.PARAMETER FarmAccount
Farm account credentials for running central admin and farm services

.EXAMPLE
.\Install-SharePoint2019.ps1 -SPInstallPath "D:\SharePoint2019" `
  -SPSetupUser "DOMAIN\SPSetup" `
  -SPSvcAccount "DOMAIN\SPService" `
  -SQLServer "SQLSERVER01" `
  -FarmAccount "DOMAIN\SPFarm" `
  -FarmPassphrase "P@ssw0rd!"
#>

param(
    [Parameter(Mandatory = $true)][string]$SPInstallPath,
    [Parameter(Mandatory = $true)][string]$SPSetupUser,
    [Parameter(Mandatory = $true)][string]$SPSvcAccount,
    [Parameter(Mandatory = $true)][string]$SQLServer,
    [Parameter(Mandatory = $true)][string]$FarmAccount,
    [Parameter(Mandatory = $true)][string]$FarmPassphrase
)

# --- Variables ---
$LogPath = "C:\SP2019InstallLogs"
New-Item -Path $LogPath -ItemType Directory -Force | Out-Null
$PrereqInstaller = Join-Path $SPInstallPath "prerequisiteinstaller.exe"
$SPSetupFile = Join-Path $SPInstallPath "setup.exe"

Write-Host "`n=== Starting SharePoint 2019 Installation ===" -ForegroundColor Cyan

# --- Step 1: Install prerequisites ---
Write-Host "`nInstalling SharePoint 2019 prerequisites..." -ForegroundColor Cyan

Start-Process -FilePath $PrereqInstaller -ArgumentList `
"/unattended",
"/SQLNCli:", "https://go.microsoft.com/fwlink/?LinkID=799013",
"/IDFX:", "https://download.microsoft.com/download/9/3/F/93F1AA10-005A-43B0-9B0D-1DB744BFA4D9/Windows6.1-KB974405-x64.msu",
"/Sync:", "https://download.microsoft.com/download/F/7/2/F726F9E4-EDB0-497F-A3E9-3A1A6900E8C2/MicrosoftSyncFrameworkRuntime-v1.0-x64-ENU.msi",
"/AppFabric:", "https://download.microsoft.com/download/1/6/3/163A76E6-55E1-4E06-9B65-60F59C1EDE86/W2K12-KB3092423-x64.msu",
"/MSIPCClient:", "https://download.microsoft.com/download/8/E/6/8E6C3B4A-25E4-4C7D-8DBA-BAB4A4D8FA1C/setup_msipc_x64.exe",
"/WCFDataServices:", "https://download.microsoft.com/download/0/1/3/013AC8E5-7D0A-4CF1-ACCE-B36B7A50AE59/WcfDataServices.exe",
"/ODBC:", "https://download.microsoft.com/download/2/2/1/2215A3E4-AE3C-4A6C-B1E1-066B8F56C3A0/msodbcsql.msi"
 -Wait -PassThru | Out-File "$LogPath\PrereqInstall.log" -Append

Write-Host "Prerequisites installed successfully." -ForegroundColor Green

# --- Step 2: Install SharePoint Binaries ---
Write-Host "`nInstalling SharePoint 2019 binaries..." -ForegroundColor Cyan
$SetupArgs = "/config $SPInstallPath\Files\SetupFarm\Config.xml"

# Create basic config file if missing
$ConfigXmlPath = Join-Path $SPInstallPath "Files\SetupFarm\Config.xml"
if (!(Test-Path $ConfigXmlPath)) {
    @"
<Configuration>
  <Package Id="sts">
    <Setting Id="LAUNCHEDFROMSETUPSTS" Value="Yes"/>
  </Package>
  <Setting Id="SERVERROLE" Value="SINGLESERVERFARM"/>
  <Setting Id="USINGUIINSTALLMODE" Value="0"/>
  <PIDKEY Value="XXXXX-XXXXX-XXXXX-XXXXX-XXXXX"/>
  <Setting Id="OFFICEMODE" Value="1"/>
  <Setting Id="ALLOWAPPS" Value="True"/>
  <Setting Id="SHOWCINUSE" Value="False"/>
  <Setting Id="SETUPTYPE" Value="CLEAN_INSTALL"/>
  <Setting Id="COMPANYNAME" Value="MyCompany"/>
  <Setting Id="USERNAME" Value="$SPSetupUser"/>
  <Setting Id="INSTALLLEVEL" Value="Default"/>
  <Setting Id="IACCEPTLICENSETERMS" Value="True"/>
</Configuration>
"@ | Out-File -Encoding ASCII $ConfigXmlPath
}

Start-Process -FilePath $SPSetupFile -ArgumentList $SetupArgs -Wait
Write-Host "SharePoint 2019 binaries installed successfully." -ForegroundColor Green

# --- Step 3: Run SharePoint Configuration Wizard ---
Write-Host "`nConfiguring SharePoint farm..." -ForegroundColor Cyan

Add-PSSnapin Microsoft.SharePoint.PowerShell -ErrorAction SilentlyContinue

$SecurePassphrase = ConvertTo-SecureString $FarmPassphrase -AsPlainText -Force
$SecureFarmAccount = Get-Credential -UserName $FarmAccount -Message "Enter farm account password"

New-SPConfigurationDatabase `
    -DatabaseName "SP_ConfigDB" `
    -DatabaseServer $SQLServer `
    -AdministrationContentDatabaseName "SP_Content_Admin" `
    -Passphrase $SecurePassphrase `
    -FarmCredentials $SecureFarmAccount

Install-SPHelpCollection -All
Initialize-SPResourceSecurity
Install-SPService
Install-SPFeature -AllExistingFeatures
New-SPCentralAdministration -Port 9999 -WindowsAuthProvider "NTLM"

Write-Host "`nRunning Products Configuration Wizard tasks..." -ForegroundColor Cyan
Install-SPApplicationContent

Write-Host "`n=== SharePoint 2019 Single-Server Installation Complete ===" -ForegroundColor Green
Write-Host "Central Administration URL: http://localhost:9999" -ForegroundColor Yellow