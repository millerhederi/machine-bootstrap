# Check if running as an adminstrator, if not, self elevate
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    # Self elivate. Must set execution policy at least to RemoteSigned for the chocolately installs
    Start-Process powershell -Verb runAs -ArgumentList "-NoExit -ExecutionPolicy RemoteSigned -Command `"& $($MyInvocation.MyCommand.Definition)`""
    return
}

cinst visualstudio2019professional -y
cinst visualstudio2019-workload-netweb -y
cinst visualstudio2019-workload-netcoretools -y
cinst resharper -y
cinst sql-server-management-studio -y
cinst jetbrains-rider -y
cinst nodejs-install -y
cinst docker-desktop -y
cinst docker-compose -y
