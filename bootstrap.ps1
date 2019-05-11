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

if (-not (Test-Path "$BootstrapDirectory")) {
    git clone https://github.com/millerhederi/machine-bootstrap.git $BootstrapDirectory
}
else {
    # The assumption is that the remote url is set to ssh, we need to update to https otherwise
    # we might get authentication issues if we have not configured our ssh key pair yet
    git -C "$BootstrapDirectory" remote set-url origin https://github.com/millerhederi/machine-bootstrap.git
    git -C "$BootstrapDirectory" fetch origin
    git -C "$BootstrapDirectory" reset --hard origin/master
    git -C "$BootstrapDirectory" clean -df
}

# Switch the remote url to ssh after cloning with the assumption we will be setting up ssh keys 
# later and will want to use those for authenticating
git -C "$BootstrapDirectory" remote set-url origin git@github.com:millerhederi/machine-bootstrap.git

& "$BootstrapDirectory\base.ps1"
