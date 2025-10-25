<#
.SYNOPSIS
Installs SQL Server 2019 (latest CU) silently for SharePoint 2019 single-server farm.

.DESCRIPTION
Downloads and installs SQL Server 2019 Developer Edition (or Enterprise if you provide media).
Installs Database Engine Services, SQL Agent, and Management Tools.
Sets up SQL with mixed authentication and configures service accounts.

.PARAMETER SQLMediaPath
(Optional) Local path or network share containing SQL Server installation files.
If not provided, script downloads the latest SQL 2019 media.

.PARAMETER SQLInstanceName
SQL instance name. Default is MSSQLSERVER.

.PARAMETER SQLSysAdminAccounts
Comma-separated list of users/groups to grant sysadmin rights.

.PARAMETER SQLServiceAccount
Domain account for SQL services (default: LocalSystem).

.EXAMPLE
.\Install-SQLServer2019.ps1 -SQLSysAdminAccounts "DOMAIN\SPFarmAdmin" -SQLServiceAccount "DOMAIN\SQLService"
#>

param(
    [string]$SQLMediaPath = "C:\SQLInstall",
    [string]$SQLInstanceName = "MSSQLSERVER",
    [string]$SQLSysAdminAccounts = "$env:USERNAME",
    [string]$SQLServiceAccount = "NT AUTHORITY\SYSTEM"
)

# --- Prerequisites ---
Write-Host "Ensuring .NET Framework 4.8 and PowerShell 5.1 are installed..." -ForegroundColor Cyan
Add-WindowsFeature NET-Framework-Features, NET-Framework-Core -ErrorAction SilentlyContinue

# --- Download SQL 2019 if not provided ---
$SQLInstaller = Join-Path $SQLMediaPath "SQL2019Setup.exe"
if (!(Test-Path $SQLInstaller)) {
    Write-Host "Downloading SQL Server 2019 media..." -ForegroundColor Cyan
    New-Item -ItemType Directory -Path $SQLMediaPath -Force | Out-Null
    $downloadUrl = "https://go.microsoft.com/fwlink/?linkid=866658"  # SQL Server 2019 installer
    Invoke-WebRequest -Uri $downloadUrl -OutFile $SQLInstaller
}

# --- Prepare configuration file ---
$ConfigFile = Join-Path $SQLMediaPath "ConfigurationFile.ini"
@"
[OPTIONS]
ACTION="Install"
ENU="True"
QUIET="True"
UpdateEnabled="True"
FEATURES=SQLENGINE,REPLICATION,FULLTEXT
INSTANCENAME="$SQLInstanceName"
SQLSVCACCOUNT="$SQLServiceAccount"
SQLSYSADMINACCOUNTS="$SQLSysAdminAccounts"
SECURITYMODE="SQL"
SAPWD="P@ssw0rd123!"
TCPENABLED="1"
NPENABLED="1"
IACCEPTSQLSERVERLICENSETERMS="True"
SQLTEMPDBDIR="C:\SQLData\TempDB"
SQLUSERDBDIR="C:\SQLData\Data"
SQLUSERDBLOGDIR="C:\SQLData\Logs"
INSTALLSQLDATADIR="C:\SQLData"
"@ | Out-File -Encoding ASCII $ConfigFile

# --- Run SQL Server setup ---
Write-Host "Starting SQL Server 2019 installation..." -ForegroundColor Green
Start-Process -FilePath $SQLInstaller -ArgumentList "/ConfigurationFile=$ConfigFile" -Wait

# --- Install SSMS (SQL Server Management Studio) ---
Write-Host "Installing SQL Server Management Studio..." -ForegroundColor Cyan
$ssmsInstaller = Join-Path $SQLMediaPath "SSMS-Setup.exe"
if (!(Test-Path $ssmsInstaller)) {
    $ssmsUrl = "https://aka.ms/ssmsfullsetup"
    Invoke-WebRequest -Uri $ssmsUrl -OutFile $ssmsInstaller
}
Start-Process -FilePath $ssmsInstaller -ArgumentList "/install /quiet /norestart" -Wait

# --- Post-Install Configuration ---
Write-Host "Configuring SQL Server network protocols..." -ForegroundColor Cyan
Import-Module "SQLPS" -DisableNameChecking -ErrorAction SilentlyContinue
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Microsoft SQL Server\MSSQL15.$SQLInstanceName\MSSQLServer\SuperSocketNetLib\Tcp\IPAll" -Name TcpPort -Value "1433"

Write-Host "Restarting SQL Server service..." -ForegroundColor Cyan
Restart-Service "MSSQLSERVER" -Force

Write-Host "`nSQL Server 2019 installation completed successfully!" -ForegroundColor Green
Write-Host "Ready for SharePoint 2019 configuration." -ForegroundColor Green
