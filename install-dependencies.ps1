############
# GO ADMIN #
############
function GoAdmin { Start-Process pwsh –Verb RunAs }

######################################
# INSTALL MODULES IF THEY DONT EXIST #
######################################
If(-not(Get-InstalledModule posh-git -ErrorAction silentlycontinue)){
	Install-Module posh-git -Scope CurrentUser -Confirm:$False -Force
}
If(-not(Get-InstalledModule oh-my-posh -ErrorAction silentlycontinue)){
	Install-Module oh-my-posh -Scope CurrentUser -RequiredVersion 2.0.412 -Confirm:$False -Force
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
If(!(Test-Path $($env:HOMEDRIVE + '\Temp'))){
	New-Item -ItemType Directory -Path $env:HOMEDRIVE -Name "Temp"
}

############################
# ADD NEW TEMP DIR TO PATH #
############################
#Get the users current path value
$CurrentValue = [Environment]::GetEnvironmentVariable("Path", "User")    
#Add the new path             
[Environment]::SetEnvironmentVariable("Path", $CurrentValue + [System.IO.Path]::PathSeparator + "C:\Temp", "User")


##################################
# WEB-SCRAPE GITHUB SCRIPT FILES #
##################################
Invoke-WebRequest -Uri "raw.githubusercontent.com/Trace-Elements0/powershellforfun/main/profile.ps1" | Select-Object -ExpandProperty Content | Out-File $profile -Encoding unicode -Force
Invoke-WebRequest -Uri "raw.githubusercontent.com/Trace-Elements0/powershellforfun/main/Show-Object.ps1" -OutFile $($env:HOMEDRIVE + '\Temp\Show-Object.ps1')
Invoke-WebRequest -Uri "raw.githubusercontent.com/Trace-Elements0/powershellforfun/main/Select-TextOutput.ps1" -OutFile $($env:HOMEDRIVE + '\Temp\Select-TextOutput.ps1')
Invoke-WebRequest -Uri "raw.githubusercontent.com/Trace-Elements0/powershellforfun/main/Get-ParameterAlias.ps1" -OutFile $($env:HOMEDRIVE + '\Temp\Get-ParameterAlias.ps1')
Invoke-WebRequest -Uri "raw.githubusercontent.com/Trace-Elements0/powershellforfun/main/Get-AliasSuggestion.ps1" -OutFile $($env:HOMEDRIVE + '\Temp\Get-AliasSuggestion.ps1')
