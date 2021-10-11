##########################################################################
# THIS SCRIPT WILL INSTALL A PROFILE ALONG WITH DEPENDENCIES NEEDED RUNS #
# WELL WITH POWERSHELL CORE 7.X; WINDOWS POWERSHELL COULD HAVE ISSUES    #
##########################################################################


####################################################
# IF NOT IN A SESSION AS ADMIN, RELOADS A SEPARATE # 
# INSTANCE + CONTINUES SCRIPT WITHIN THAT SESSION  #
####################################################
param([switch]$Elevated)
function Test-Admin {
    $currentUser = New-Object Security.Principal.WindowsPrincipal $(
        [Security.Principal.WindowsIdentity]::GetCurrent()
    )
    $currentUser.IsInRole(
        [Security.Principal.WindowsBuiltinRole]::Administrator
    )
}
if (!(Test-Admin))  {
    if ($Elevated) {
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
If(-not(Get-InstalledModule posh-git -ErrorAction silentlycontinue)){
	Install-Module posh-git -Scope CurrentUser -Confirm:$False -Force
}
If(-not(Get-InstalledModule oh-my-posh -ErrorAction silentlycontinue)){
	Install-Module oh-my-posh -Scope CurrentUser -Confirm:$False -Force
}
If(-not(Get-InstalledModule PSReadline -AllowPrerelease -ErrorAction silentlycontinue)){
	Install-Module PSReadline -Scope CurrentUser -AllowPrerelease -Confirm:$False -Force
}
If(-not(Get-InstalledModule Terminal-Icons -ErrorAction silentlycontinue)){
	Install-Module Terminal-Icons -Scope CurrentUser -Confirm:$False -Force
}

############################################
# CREATE BLANK PROFILE IF ONE DOESNT EXIST #
############################################
If(!(Test-Path $profile)){
	New-Item -ItemType File -Force -Path $profile
}

###################################################
# CREATE BLANK C:\TEMP FOLDER IF ONE DOESNT EXIST #
###################################################
If(!(Test-Path "$env:HOMEDRIVE\Temp")){
	New-Item -ItemType Directory -Path $env:HOMEDRIVE -Name 'Temp'
}

############################
# ADD NEW TEMP DIR TO PATH #
############################
# Get the users current path value
$CurrentValue = [Environment]::GetEnvironmentVariable('Path', 'User')    
# Add the new path, careful when using this second part manually
If($CurrentValue){
	[Environment]::SetEnvironmentVariable('Path', $CurrentValue + [System.IO.Path]::PathSeparator + "$env:HOMEDRIVE\Temp", 'User')
}

##################################
# WEB-SCRAPE GITHUB SCRIPT FILES #
##################################
Invoke-WebRequest -Uri 'raw.githubusercontent.com/Trace-Elements0/powershellforfun/main/profile.ps1' | Select-Object -ExpandProperty Content | Out-File $profile -Encoding unicode -Force
Invoke-WebRequest -Uri 'raw.githubusercontent.com/Trace-Elements0/powershellforfun/main/Show-Object.ps1' -OutFile "$env:HOMEDRIVE\Temp\Show-Object.ps1"
Invoke-WebRequest -Uri 'raw.githubusercontent.com/Trace-Elements0/powershellforfun/main/Select-TextOutput.ps1' -OutFile "$env:HOMEDRIVE\Temp\Select-TextOutput.ps1"
Invoke-WebRequest -Uri 'raw.githubusercontent.com/Trace-Elements0/powershellforfun/main/Get-ParameterAlias.ps1' -OutFile "$env:HOMEDRIVE\Temp\Get-ParameterAlias.ps1"
Invoke-WebRequest -Uri 'raw.githubusercontent.com/Trace-Elements0/powershellforfun/main/Get-AliasSuggestion.ps1' -OutFile "$env:HOMEDRIVE\Temp\Get-AliasSuggestion.ps1"
