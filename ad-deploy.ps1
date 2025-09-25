# ad-deploy.ps1
# Installs AD DS and creates a new forest "lab.local"
# WARNING: Change domain name and password before running in any environment.

# --- Configuration (EDIT BEFORE RUNNING) ---
$DomainName = "lab.local"
$SafeModePwdPlain = "P@ssw0rd!ChangeMe"   # CHANGE THIS to a secure password
$SafeModePwd = ConvertTo-SecureString $SafeModePwdPlain -AsPlainText -Force
$NetBiosName = "LAB"

# --- Install AD DS role and management tools ---
Write-Host "Installing AD DS role..." -ForegroundColor Cyan
Install-WindowsFeature -Name AD-Domain-Services -IncludeManagementTools

# --- Import deployment module ---
Import-Module ADDSDeployment

# --- Promote to Domain Controller and create a new forest ---
Write-Host "Promoting server to domain controller for domain $DomainName ..." -ForegroundColor Cyan
Install-ADDSForest `
    -DomainName $DomainName `
    -DomainNetbiosName $NetBiosName `
    -SafeModeAdministratorPassword $SafeModePwd `
    -InstallDNS `
    -CreateDNSDelegation:$false `
    -Force:$true

Write-Host "AD DS promotion command issued. The server will reboot automatically as part of promotion." -ForegroundColor Green

# After the server reboots and AD is online, optionally configure DNS forwarders:
# Example (run on the promoted DC after reboot):
# Add-DnsServerForwarder -IPAddress "8.8.8.8","1.1.1.1"
