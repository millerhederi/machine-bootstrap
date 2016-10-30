$Host.UI.RawUI.WindowTitle = 'PowerShell'

$dev = "$env:HomeDrive\dev"
$scripts = "$(Split-Path $Profile)\Scripts"

$env:path += ";$scripts"

Import-Module posh-git
Import-Module z

Set-Location -Path $dev