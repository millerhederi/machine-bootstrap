$ErrorActionPreference="Stop"

# Check if running as an adminstrator, if not, self elevate
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator))
{
    # Self elivate. Must set execution policy at least to RemoteSigned for the chocolately installs
    Start-Process powershell -Verb runAs -ArgumentList "-NoExit -ExecutionPolicy RemoteSigned -Command `"& $($MyInvocation.MyCommand.Definition)`""
    return
}

$DotfilesDirectory = "$env:HomeDrive\dev\git\millerhederi\machine-bootstrap\dotfiles"

#region Powershell Profile
$ScriptsDirectory = "$(Split-Path $Profile)\Scripts"
New-Item -ItemType Directory -Path "$(Split-Path $Profile)" -Force
New-Item -ItemType SymbolicLink -Path "$Profile" -Value "$DotfilesDirectory\Powershell\Microsoft.PowerShell_profile.ps1" -Force
New-Item -ItemType SymbolicLink -Path "$ScriptsDirectory" -Value "$DotfilesDirectory\Powershell\Scripts" -Force
$env:path += ";$ScriptsDirectory" # Add to path so we can use scripts below
#endregion

# Enable long file paths
New-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\FileSystem' -Name LongPathsEnabled -Value 1 -PropertyType DWORD -Force

#region Configure Windows Explorer
$ExplorerRegKey = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced'
Set-ItemProperty -Path $ExplorerRegKey -Name Hidden -Value 1          # Show hidden files
Set-ItemProperty -Path $ExplorerRegKey -Name HideFileExt -Value 0     # Show file extensions
Set-ItemProperty -Path $ExplorerRegKey -Name ShowSuperHidden -Value 0 # Hide system hidden files
Set-ItemProperty -Path $ExplorerRegKey -Name LaunchTo -Value 1        # Open to `This PC` instead of `Quick Access`
New-ItemProperty -Path $ExplorerRegKey -Name AutoCheckSelect -Value 0 -PropertyType DWORD -Force # Turn off `Use check boxes to select items`

$SearchRegKey = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Search'
Set-ItemProperty -Path $SearchRegKey -Name SearchboxTaskbarMode -Value 0 # Hide Cortana search box in task bar
Set-ItemProperty -Path $SearchRegKey -Name BingSearchEnabled -Value 0    # Disable Bing search results from start menu

Add-QuickAccess -Path "$env:HomeDrive\dev\git"
Add-QuickAccess -Path "$env:UserProfile"

Stop-Process -ProcessName explorer
#endregion

#region Theme Windows
$DwmRegKey = 'HKCU:\Software\Microsoft\Windows\DWM'
New-ItemProperty -Path $DwmRegKey -Name ColorPrevalence -Value 1 -PropertyType DWORD -Force              # Enable setting color of title bar
New-ItemProperty -Path $DwmRegKey -Name AccentColor -Value 4282927692 -PropertyType DWORD -Force         # Set active title bar color to dark gray
New-ItemProperty -Path $DwmRegKey -Name AccentColorInactive -Value 4282927692 -PropertyType DWORD -Force # Set inactive title bar color to dark gray
#endregion

#region Visual Studio Code
New-Item -ItemType Directory -Path "$env:AppData\Code\User" -Force
New-Item -ItemType SymbolicLink -Path "$env:AppData\Code\User\settings.json" -Value "$DotfilesDirectory\VSCode\User\settings.json" -Force
cinst vscode -y
$env:Path += ";${env:ProgramFiles}\Microsoft VS Code\bin"
code --install-extension ms-vscode.PowerShell
code --install-extension ms-vscode.sublime-keybindings
code --install-extension Ionide.Ionide-fsharp
code --install-extension ms-azuretools.vscode-docker
code --install-extension mark-hansen.hledger-vscode
code --install-extension dsznajder.es7-react-js-snippets
code --install-extension ms-vscode-remote.remote-wsl
#endregion

#region Configure .gitconfig
if  (-not (Test-Path "$env:UserProfile\.gitconfig")) {
    Copy-Item -Path "$DotfilesDirectory\Git\.gitconfig" -Destination "$env:UserProfile\.gitconfig"
}

New-Item -ItemType SymbolicLink -Path "$env:UserProfile\.gitconfig_xplat" -Value "$DotfilesDirectory\Git\.gitconfig_xplat" -Force
New-Item -ItemType SymbolicLink -Path "$env:UserProfile\.gitconfig_plat" -Value "$DotfilesDirectory\Git\.gitconfig_windows" -Force
#endregion

#region VeraCrypt
New-Item -ItemType Directory -Path "$env:AppData\VeraCrypt" -Force
New-Item -ItemType SymbolicLink -Path "$env:AppData\VeraCrypt\Configuration.xml" -Value "$DotfilesDirectory\VeraCrypt\Configuration.xml" -Force
cinst veracrypt -y
#endregion

#region SublimeMerge
New-Item -ItemType Directory -Path "$env:AppData\Sublime Merge\Packages" -Force
New-Item -ItemType SymbolicLink -Path "$env:AppData\Sublime Merge\Packages\User" -Value "$DotfilesDirectory\SublimeMerge\Packages\User" -Force
cinst sublimemerge -y
#endregion

#region SublimeText
New-Item -ItemType Directory -Path "$env:AppData\Sublime Text 3\Packages\User" -Force
New-Item -ItemType SymbolicLink -Path "$env:AppData\Sublime Text 3\Packages\User\Package Control.sublime-settings" -Value "$DotfilesDirectory\SublimeText\Packages\User\Package Control.sublime-settings" -Force
New-Item -ItemType SymbolicLink -Path "$env:AppData\Sublime Text 3\Packages\User\Preferences.sublime-settings" -Value "$DotfilesDirectory\SublimeText\Packages\User\Preferences.sublime-settings" -Force
New-Item -ItemType SymbolicLink -Path "$env:AppData\Sublime Text 3\Packages\Snippets" -Value "$DotfilesDirectory\SublimeText\Packages\Snippets" -Force
cinst sublimetext3 -y
Write-Output 'st3' | cinst sublimetext3.packagecontrol -y
#endregion

#region WSL
Enable-WindowsOptionalFeature -Online -NoRestart -FeatureName Microsoft-Windows-Subsystem-Linux

if (-not (Get-AppxPackage CanonicalGroupLimited.Ubuntu18.04onWindows -ErrorAction SilentlyContinue)) {
    & {
        # Progress bar might have an impact on performance when downloading ubuntu, see
        # https://github.com/PowerShell/PowerShell/issues/2138.
        $ProgressPreference = 'SilentlyContinue'
        Write-Host "Downloading Ubuntu .appx package..."
        Invoke-WebRequest -Uri https://aka.ms/wsl-ubuntu-1804 -OutFile "$env:TEMP\Ubuntu.appx" -UseBasicParsing
    }

    Add-AppxPackage -Path $env:TEMP\Ubuntu.appx

    $UbuntuDirectory = (Get-AppxPackage CanonicalGroupLimited.Ubuntu18.04onWindows).InstallLocation
    New-ItemProperty `
        HKCU:\Software\Microsoft\Windows\CurrentVersion\RunOnce `
        -Name InitWSL `
        -Value "powershell.exe -NoExit `"& { & '$UbuntuDirectory\ubuntu1804.exe' -c '/mnt/c/dev/git/millerhederi/machine-bootstrap/wsl/bootstrap.sh' }`"" `
        -Force
}
#endregion

Enable-WindowsOptionalFeature -Online -NoRestart -FeatureName Microsoft-Hyper-V -All

Install-PackageProvider -Name Nuget -Force
Install-Module -Name posh-git -Scope CurrentUser -Force
Install-Module -Name z -Scope CurrentUser -AllowClobber -Force
Install-Module -Name AWSPowerShell -Scope CurrentUser -AllowClobber -Force
Install-Module -Name SqlServer -Scope CurrentUser -AllowClobber -Force

cinst googlechrome -y
cinst firefox -y
cinst slack -y
cinst 7zip.install -y
cinst openvpn -y
cinst dropbox -y
cinst youtube-dl -y
cinst windirstat -y
cinst sdelete -y
cinst procexp -y
cinst vlc -y
cinst beyondcompare -y
cinst insomnia-rest-api-client -y
cinst keepass -y
cinst keepass-yet-another-favicon-downloader -y
cinst microsoft-windows-terminal -y

cinst visualstudio2019community -y
cinst visualstudio2019-workload-netweb -y
cinst visualstudio2019-workload-netcoretools -y
cinst resharper -y
cinst sql-server-management-studio -y
cinst mysql.workbench -y
cinst jetbrains-rider -y
cinst docker-desktop -y
cinst docker-compose -y
cinst nodejs.install -y
cinst gh -y

# Remove all desktop icons
Remove-Item "$env:UserProfile\Desktop\*.lnk"