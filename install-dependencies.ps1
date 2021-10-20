<#
    .AUTHOR
        Julian D. Edington (github.com/jedington).
	.SYNOPSIS
        Installer script for 'powershellforfun' by Jorge Sanchez (github.com/Trace-Elements0).
    .DESCRIPTION
        Installs:
            - 'powershellforfun' profile.
            - 4 referenced script files also within the 'powershellforfun' repo.
            - 4 open-source modules (posh-git, oh-my-posh, PSReadline, Terminal-Icons).
    .NOTES
		This most likely won't work in any PowerShell versions older than 5.1*
#>

##########################################
# FORCE RUN SCRIPT AS ADMIN AND CONTINUE #
##########################################
param([switch]$elevated)
if (!($elevated)) {
    if ([bool]($PSVersionTable | Where-Object PSVersion -like 5.1* -EA 0)) {
        Start-Process powershell.exe -Verb RunAs -ArgumentList (
            '-noprofile -noexit -file "{0}" -elevated' -f (
                $myinvocation.MyCommand.Definition
            )
        )    
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
	New-Item -ItemType File -Path $profile -Force
}

###################################################
# CREATE BLANK C:\TEMP FOLDER IF ONE DOESNT EXIST #
###################################################
if (!(Test-Path "$env:HOMEDRIVE\Temp")) {
	New-Item -ItemType Directory -Path $env:HOMEDRIVE -Name 'Temp' -Force
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
