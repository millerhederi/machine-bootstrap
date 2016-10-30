$DotfilesDirectory = "$env:HomeDrive\dev\git\millerhederi\machine-bootstrap\dotfiles"

#region Configure Windows Explorer
# http://stackoverflow.com/questions/4491999/configure-windows-explorer-folder-options-through-powershell
$ExplorerRegKey = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced'
Set-ItemProperty -Path $ExplorerRegKey -Name Hidden -Value 1          # Show hidden files
Set-ItemProperty -Path $ExplorerRegKey -Name HideFileExt -Value 0     # Show file extensions
Set-ItemProperty -Path $ExplorerRegKey -Name ShowSuperHidden -Value 0 # Hide system hidden files
Set-ItemProperty -Path $ExplorerRegKey -Name LaunchTo -Value 1        # Open to `This PC` instead of `Quick Access`
Stop-Process -ProcessName explorer
#endregion

#region Powershell Profile
New-Item -ItemType Directory -Path "$(Split-Path $Profile)" -Force
New-Item -ItemType SymbolicLink -Path "$Profile" -Value "$DotfilesDirectory\Powershell\Microsoft.PowerShell_profile.ps1"
New-Item -ItemType SymbolicLink -Path "$(Split-Path $Profile)\Scripts" -Value "$DotfilesDirectory\Powershell\Scripts"
#endregion

#region Visual Studio Code
New-Item -ItemType Directory -Path "$env:AppData\Code" -Force
New-Item -ItemType SymbolicLink -Path "$env:AppData\Code\User" -Value "$DotfilesDirectory\VSCode\User"
cinst vscode -y
$env:Path += ";${env:ProgramFiles}\Microsoft VS Code\bin"
code --install-extension ms-vscode.PowerShell
code --install-extension ms-vscode.sublime-keybindings
code --install-extension ms-python.python
code --install-extension ms-vscode.Go
code --install-extension Ionide.Ionide-fsharp
#endregion

#region ConEmu
Copy-Item -Path "$DotfilesDirectory\ConEmu\ConEmu.xml" -Destination "$env:AppData\ConEmu.xml"
cinst conemu -y
#endregion

#region Configure .gitconfig
New-Item -ItemType SymbolicLink -Path "$env:UserProfile\.gitconfig" -Value "$DotfilesDirectory\Git\.gitconfig"
#endregion

#region VeraCrypt
New-Item -ItemType Directory -Path "$env:AppData\VeraCrypt" -Force
New-Item -ItemType SymbolicLink -Path "$env:AppData\VeraCrypt\Configuration.xml" -Value "$DotfilesDirectory\VeraCrypt\Configuration.xml"
cinst veracrypt -y
#endregion

#region SublimeMerge
New-Item -ItemType Directory -Path "$env:AppData\Sublime Merge\Packages" -Force
New-Item -ItemType SymbolicLink -Path "$env:AppData\Sublime Merge\Packages\User" -Value "$DotfilesDirectory\SublimeMerge\Packages\User"
# There is no chocolatey package for sublime merge yet
#endregion

#region SublimeText
New-Item -ItemType Directory -Path "$env:AppData\Sublime Text 3\Packages\User" -Force
New-Item -ItemType SymbolicLink -Path "$env:AppData\Sublime Text 3\Packages\User\Package Control.sublime-settings" -Value "$DotfilesDirectory\SublimeText\Packages\User\Package Control.sublime-settings"
New-Item -ItemType SymbolicLink -Path "$env:AppData\Sublime Text 3\Packages\User\Preferences.sublime-settings" -Value "$DotfilesDirectory\SublimeText\Packages\User\Preferences.sublime-settings"
New-Item -ItemType SymbolicLink -Path "$env:AppData\Sublime Text 3\Packages\Snippets" -Value "$DotfilesDirectory\SublimeText\Packages\Snippets"
cinst sublimetext3 -y
Write-Output 'st3' | cinst sublimetext3.packagecontrol -y
#endregion

Install-PackageProvider -Name Nuget -Force
Install-Module -Name posh-git -Scope CurrentUser -Force
Install-Module -Name z -Scope CurrentUser -AllowClobber -Force

cinst googlechrome -y
cinst firefox -y
cinst slack -y
cinst 7zip.install -y
cinst openvpn -y
cinst dropbox -y
cinst youtube-dl -y
cinst f.lux -y
cinst windirstat -y
cinst sdelete -y
cinst procexp -y
cinst vlc -y
cinst beyondcompare -y
cinst postman -y
cinst keepass -y
