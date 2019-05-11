<#
.SYNOPSIS 
Open File Explorer to a given path.

.DESCRIPTION
Open File Explorer to a given path.

.PARAMETER Path

The path to open File Explorer to.

.Example

PS>Open-Explorer -Path "C:\dev"

Opens File Explorer to the path "C:\dev".

.Example

PS>Open-Explorer

Opens File Explorer to the current working directory.
#>
param (
    [Parameter(Position = 0)]
    $Path = '.'
)

explorer.exe $Path
