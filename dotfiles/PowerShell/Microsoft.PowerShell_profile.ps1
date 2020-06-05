$env:Path += ";$(Split-Path $Profile)\Scripts"
$env:Path += ";$env:ProgramFiles\Sublime Merge"

Import-Module posh-git
Import-Module oh-my-posh
Import-Module z

#region Load private profiles
$PrivateProfilesRootDirectory = "$(Split-Path $Profile)\.private"
if (Test-Path -Path $PrivateProfilesRootDirectory -PathType Container)
{
    Get-ChildItem -Path $PrivateProfilesRootDirectory -Include profile.ps1 -Recurse | ForEach-Object { . $_.FullName }
}
#endregion

Set-Theme Paradox-Custom

Initialize-PsShortcut
