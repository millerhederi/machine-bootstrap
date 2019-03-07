$Host.UI.RawUI.WindowTitle = 'PowerShell'

$dev = "$env:HomeDrive\dev"
$scripts = "$(Split-Path $Profile)\Scripts"

$env:path += ";$scripts"

Import-Module posh-git
Import-Module z

#region Load private profiles
$PrivateProfilesRootDirectory = "$(Split-Path $Profile)\.private"
if (Test-Path -Path $PrivateProfilesRootDirectory -PathType Container)
{
    Get-ChildItem -Path $PrivateProfilesRootDirectory -Include profile.ps1 -Recurse | ForEach-Object { . $_.FullName }
}
#endregion

function gcob ([string]$branch) {
    git checkout -b $branch
}

function gwip ([string]$message) {
    if (!$message) {
        $message = "WIP"
    }
    else {
        $message = "WIP: " + $message
    }

    git commit -m $message
}

Set-Alias e Open-Explorer

Set-Location -Path $dev
