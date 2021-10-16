########################################################################
# THIS SCRIPT WILL INSTALL A PROFILE ALONG WITH DEPENDENCIES NEEDED.   #
# GOOD WITH POWERSHELL CORE 7.X; WINDOWS POWERSHELL COULD HAVE ISSUES. #
########################################################################


####################################################
# IF NOT IN A SESSION AS ADMIN, RELOADS A SEPARATE # 
# INSTANCE + CONTINUES SCRIPT WITHIN THAT SESSION  #
####################################################
param([switch]$elevated)
function Test-Admin {
    $currentUser = New-Object Security.Principal.WindowsPrincipal $(
        [Security.Principal.WindowsIdentity]::GetCurrent()
    )
    $currentUser.IsInRole(
        [Security.Principal.WindowsBuiltinRole]::Administrator
    )
}
if (!(Test-Admin)) {
    if ($elevated) {
        # tried to elevate, did not work, aborting
    } 
    else {
        Start-Process pwsh.exe -Verb RunAs -ArgumentList (
            '-noprofile -noexit -file "{0}" -elevated' -f (
                $myinvocation.MyCommand.Definition
            )
        )
    }
    exit
}

######################################
# INSTALL MODULES IF THEY DONT EXIST #
######################################
if (!(Get-InstalledModule posh-git -EA 0)) {
	Install-Module posh-git -Scope CurrentUser -Confirm:$False -Force
}
if (!(Get-InstalledModule oh-my-posh -EA 0)) {
	Install-Module oh-my-posh -Scope CurrentUser -Confirm:$False -Force
}
if (!(Get-InstalledModule PSReadline -AllowPrerelease -EA 0)) {
	Install-Module PSReadline -Scope CurrentUser -AllowPrerelease -Confirm:$False -Force
}
if (!(Get-InstalledModule Terminal-Icons -EA 0)) {
	Install-Module Terminal-Icons -Scope CurrentUser -Confirm:$False -Force
}

############################################
# CREATE BLANK PROFILE IF ONE DOESNT EXIST #
############################################
if (!(Test-Path $profile)) {
	New-Item -ItemType File -Force -Path $profile
}

###################################################
# CREATE BLANK C:\TEMP FOLDER IF ONE DOESNT EXIST #
###################################################
if (!(Test-Path "$env:HOMEDRIVE\Temp")) {
	New-Item -ItemType Directory -Path $env:HOMEDRIVE -Name 'Temp'
}

############################
# ADD NEW TEMP DIR TO PATH #
############################
# Get the users current path value
$currentValue = [Environment]::GetEnvironmentVariable('Path', 'User')    
# Add the new path, careful when using this second part manually
if ([bool]$currentValue) {
	[Environment]::SetEnvironmentVariable(
        'Path', $currentValue + [System.IO.Path]::PathSeparator + "$env:HOMEDRIVE\Temp", 'User'
    )
}

##################################
# WEB-SCRAPE GITHUB SCRIPT FILES #
##################################
$repo = 'raw.githubusercontent.com/Trace-Elements0/powershellforfun/main'
Invoke-WebRequest -Uri "$repo/profile.ps1" | Select-Object -ExpandProperty Content | Out-File $profile -Encoding unicode -Force
Invoke-WebRequest -Uri "$repo/Show-Object.ps1" -OutFile "$env:HOMEDRIVE\Temp\Show-Object.ps1"
Invoke-WebRequest -Uri "$repo/Select-TextOutput.ps1" -OutFile "$env:HOMEDRIVE\Temp\Select-TextOutput.ps1"
Invoke-WebRequest -Uri "$repo/Get-ParameterAlias.ps1" -OutFile "$env:HOMEDRIVE\Temp\Get-ParameterAlias.ps1"
Invoke-WebRequest -Uri "$repo/Get-AliasSuggestion.ps1" -OutFile "$env:HOMEDRIVE\Temp\Get-AliasSuggestion.ps1"
