<#
.SYNOPSIS 
Pin a folder to Quick Access in File Explorer.

.DESCRIPTION
Pin a folder to Quick Access in File Explorer.

.PARAMETER Path

The path to be pinned to Quick Access.

.Example

PS>Add-QuickAccess -Path "C:\dev"

Pins the path "C:\dev" to Quick Access with name "dev".
#>
[CmdletBinding()]
param (
    [Parameter(Mandatory=$true)]
    [string]$Path
)

if (!(Test-Path -Path "$Path"))
{
    throw "The path '$Path' does not exists."
}

$QuickAccess = New-Object -ComObject shell.application
$QuickAccess.Namespace("$Path").Self.InvokeVerb("pintohome")
