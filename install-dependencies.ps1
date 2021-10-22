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

############################################
# CREATE BLANK PROFILE IF ONE DOESNT EXIST #
############################################
$repo = 'raw.githubusercontent.com/Trace-Elements0/powershellforfun/main'
if (!(Test-Path $profile)) {
	New-Item -ItemType File -Path $profile -Force
    
    ##################################
    # WEB-SCRAPE GITHUB SCRIPT FILES #
    ##################################
    Invoke-WebRequest -Uri "$repo/profile.ps1" | 
        Select-Object -ExpandProperty Content | 
            Out-File $profile -Encoding unicode -Force

}
else {
    ###################
    # PROFILE CHOICES #
    ###################
    do {
        Write-Host '<<<----------------------->>>' -f Magenta
        Write-Host '<<< [1] OVERWRITE PROFILE >>>' -f Magenta
        Write-Host '<<< [2] APPEND TO PROFILE >>>' -f Magenta
        Write-Host '<<< [3] SKIP              >>>' -f Magenta
        Write-Host '<<<----------------------->>>' -f Magenta
        Write-Host 'WARNING, OPT 1 OVERWRITES POWERSHELL USER PROFILE COMPLETELY.' -f Magenta
        try {
            [int]$num = Read-Host `n'Choose: 1 / 2 / 3'
            if (($num -le 0) -or ($num -ge 6)) {
                Write-Host `n'Wrong... Only accepts these options: 1/2/3'`n -f Magenta
            }
        }
        catch [System.OutOfMemoryException] {
            # catch invalid input
        }
    } while (($num -le 0) -or ($num -ge 4))
    switch($num) {
        1 {
            Invoke-WebRequest -Uri "$repo/profile.ps1" | 
                Select-Object -ExpandProperty Content | 
                    Out-File $profile -Encoding unicode -Force
        }
        2 {
            Invoke-WebRequest -Uri "$repo/profile.ps1" | 
                Select-Object -ExpandProperty Content |
                    Out-File $profile -Append -Encoding unicode -Force
        }
        3 {
            # skip
        }
    }
}


##################################
# WEB-SCRAPE GITHUB SCRIPT FILES #
##################################
Invoke-WebRequest -Uri "$repo/Show-Object.ps1" -OutFile "$env:HOMEDRIVE\Temp\Show-Object.ps1"
Invoke-WebRequest -Uri "$repo/Select-TextOutput.ps1" -OutFile "$env:HOMEDRIVE\Temp\Select-TextOutput.ps1"
Invoke-WebRequest -Uri "$repo/Get-ParameterAlias.ps1" -OutFile "$env:HOMEDRIVE\Temp\Get-ParameterAlias.ps1"
Invoke-WebRequest -Uri "$repo/Get-AliasSuggestion.ps1" -OutFile "$env:HOMEDRIVE\Temp\Get-AliasSuggestion.ps1"
