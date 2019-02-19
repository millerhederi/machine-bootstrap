$ErrorActionPreference="Stop"

# Check if running as an adminstrator, if not, self elevate
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator))
{
    # Self elivate. Must set execution policy at least to RemoteSigned for the chocolately installs
    Start-Process powershell -Verb runAs -ArgumentList "-NoExit -ExecutionPolicy RemoteSigned -Command `"& $($MyInvocation.MyCommand.Definition)`""
    return
}

Set-ExecutionPolicy RemoteSigned -Scope CurrentUser -Force

# Install chocolatey
Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

cinst git -y

Import-Module "$env:ChocolateyInstall\helpers\chocolateyInstaller.psm1"
Update-SessionEnvironment

$BootstrapDirectory = "$env:HomeDrive\dev\git\millerhederi\machine-bootstrap"

# Clone repo via https since we have not set up our ssh public/private key pair yet, but switch
# remote url to ssh after cloning with the assumption we will be setting up ssh keys later and
# will want to use those for authenticating
git clone https://github.com/millerhederi/machine-bootstrap.git $BootstrapDirectory
git -C "$BootstrapDirectory" remote set-url origin git@github.com:millerhederi/machine-bootstrap.git

& "$BootstrapDirectory\base.ps1"
