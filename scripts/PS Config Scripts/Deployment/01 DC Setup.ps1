#Install-WindowsFeature -Name AD-Domain-Services -IncludeManagementTools
Import-Module ADDSDeployment
Install-ADDSForest -DomainName "corp.local" -CreateDnsDelegation:$false -DatabasePath "C:\Windows\NTDS" -DomainMode "Win2016" -DomainNetbiosName "CORP" -ForestMode "Win2016" -LogPath "C:\Windows\NTDS" -SysvolPath "C:\Windows\SYSVOL" -InstallDNS:$true -Force
