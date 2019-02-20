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

Set-Location -Path $dev
