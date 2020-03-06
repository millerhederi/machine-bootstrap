foreach ($entry in Get-PsShortcut) {
    $shortcut = $entry.Shortcut
    $functionName = "_psshortcut_$shortcut"
    Invoke-Expression "function global:$functionName() { Invoke-Expression `"$($entry.Expression)`" }"
    Set-Alias -Name $shortcut -Value $functionName -Scope Global
}