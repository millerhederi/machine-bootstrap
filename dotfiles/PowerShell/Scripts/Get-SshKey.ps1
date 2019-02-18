<#
.SYNOPSIS 
Get the public ssh key.

.DESCRIPTION
Get the public ssh key. If a public/private ssh key pair does not already exist, first generate one.

.Example

PS>Get-SshKey

Returns the content of the public ssh key.

.Example

PS>Get-SshKey | Set-Clipboard

Copy the conent of the public ssh key to the clipboard.
#>
$SshKeyPath = "$env:UserProfile\.ssh"

if (!(Test-Path -Path "$SshKeyPath\id_rsa"))
{
    New-Item -ItemType Directory -Path "$SshKeyPath" -Force | Out-Null
    & "$env:ProgramFiles\Git\usr\bin\ssh-keygen.exe" -f "$SshKeyPath\id_rsa" -t rsa -N "''" | Out-Null
}

Get-Content "$SshKeyPath\id_rsa.pub"