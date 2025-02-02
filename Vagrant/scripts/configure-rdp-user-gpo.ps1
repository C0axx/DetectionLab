# Purpose: Install the GPO that allows PIRATESHIP\vagrant to RDP
Write-Host "$('[{0:HH:mm}]' -f (Get-Date)) Importing the GPO to allow PIRATESHIP/vagrant to RDP..."
Import-GPO -BackupGpoName 'Allow Domain Users RDP' -Path "c:\vagrant\resources\GPO\rdp_users" -MigrationTable "c:\vagrant\resources\GPO\rdp_users\rdp_users.migtable" -TargetName 'Allow Domain Users RDP' -CreateIfNeeded

$OU = "ou=Workstations,DC=pirate,DC=ship"
$gPLinks = $null
$gPLinks = Get-ADOrganizationalUnit -Identity $OU -Properties name,distinguishedName, gPLink, gPOptions
$GPO = Get-GPO -Name 'Allow Domain Users RDP'
If ($gPLinks.LinkedGroupPolicyObjects -notcontains $gpo.path)
{
  New-GPLink -Name 'Allow Domain Users RDP' -Target $OU -Enforced yes
}
else
{
  Write-Host "$('[{0:HH:mm}]' -f (Get-Date)) Allow Domain Users RDP GPO was already linked at $OU. Moving On."
}
$OU = "ou=Servers,DC=pirate,DC=ship"
$gPLinks = $null
$gPLinks = Get-ADOrganizationalUnit -Identity $OU -Properties name,distinguishedName, gPLink, gPOptions
$GPO = Get-GPO -Name 'Allow Domain Users RDP'
If ($gPLinks.LinkedGroupPolicyObjects -notcontains $gpo.path)
{
    New-GPLink -Name 'Allow Domain Users RDP' -Target $OU -Enforced yes
}
else
{
  Write-Host "$('[{0:HH:mm}]' -f (Get-Date)) Allow Domain Users RDP GPO was already linked at $OU. Moving On."
}
gpupdate /force
