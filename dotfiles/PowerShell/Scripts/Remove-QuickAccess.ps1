<#
.SYNOPSIS 
Unpin a folder from Quick Access in File Explorer.

.DESCRIPTION
Unpin a folder from Quick Access in File Explorer.

.PARAMETER Path

The path to be unpinned to Quick Access.

.Example

PS>Remove-QuickAccess -Path "C:\dev"

Unpins the path "C:\dev" from Quick Access.
#>
[CmdletBinding()]
param (
    [Parameter(Mandatory=$true)]
    [string]$Path
)

$QuickAccess = New-Object -ComObject shell.application
$Target = $QuickAccess.Namespace("shell:::{679f85cb-0220-4080-b29b-5540cc05aab6}").Items() | Where-Object { $_.Path -eq "$Path" }

if ($null -eq $Target)
{
    throw "The path '$Path' is not pinned to Quick Access."
}

$Target.InvokeVerb("unpinfromhome")
