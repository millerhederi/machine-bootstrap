Import-Csv -Path (Join-Path -Path (Split-Path -Path "$Profile") -ChildPath ".psshortcut") `
    | Sort-Object -Property Shortcut