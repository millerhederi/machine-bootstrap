Install-Module -Name posh-git -Scope CurrentUser -Force
Install-Module -Name oh-my-posh -Scope CurrentUser -Force
Install-Module -Name z -Scope CurrentUser -Force
Install-Module -Name PSReadLine -AllowPrerelease -Scope CurrentUser -Force -SkipPublisherCheck

Install-Module -Name AWS.Tools.Installer -Force
Install-AWSToolsModule AWS.Tools.ECS,AWS.Tools.ECR -CleanUp -Confirm:$False