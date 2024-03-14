#region Load private profiles
$PrivateProfilesRootDirectory = "$(Split-Path $Profile)\.private"
if (Test-Path -Path $PrivateProfilesRootDirectory -PathType Container)
{
    Get-ChildItem -Path $PrivateProfilesRootDirectory -Include profile.ps1 -Recurse | ForEach-Object { . $_.FullName }
}
#endregion

Invoke-Expression (&starship init powershell)
