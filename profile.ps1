<#
    .AUTHOR 
	Jorge Sanchez
    .SYNOPSIS
        Profile File
    .DESCRIPTION
        Profile File
    .NOTES
#>

#########################
# WINDOWS, PATH, HELP   #
#########################

# Refresh my local help
Start-Job -Name "UpdateHelp" -ScriptBlock { Update-Help -Force -Verbose -ErrorAction SilentlyContinue -UICulture en-US  } | Out-Null
Write-Host "Updating Help in background (Get-Help to check)" -ForegroundColor Yellow

# Show PS Version and date/time
Write-Host "PowerShell Version: $($psversiontable.psversion) - ExecutionPolicy: $(Get-ExecutionPolicy)" -ForegroundColor yellow

#############
# IMPORTS   #
#############
Import-Module posh-git -SkipEditionCheck
Import-Module oh-my-posh -SkipEditionCheck
Import-Module PSReadLine
Import-Module Terminal-Icons

Set-PSReadLineOption -PredictionSource History
Set-PSReadLineOption -PredictionViewStyle ListView
Set-PSReadLineOption -EditMode Windows
Set-PSReadLineKeyHandler -Chord 'Alt+,' -ScriptBlock {
	Set-Location -
		[Microsoft.PowerShell.PSConsoleReadLine]::RevertLine()
		[Microsoft.PowerShell.PSConsoleReadLine]::AcceptLine()
}
Set-PSReadLineKeyHandler -Chord 'Alt+.' -ScriptBlock {
	Set-Location +
		[Microsoft.PowerShell.PSConsoleReadLine]::RevertLine()
		[Microsoft.PowerShell.PSConsoleReadLine]::AcceptLine()
}

###########
# ALIASES #
###########
Set-Alias -Name new -Value New-Item
Set-Alias -Name Keep-History -Value fnHistory
Set-Alias -Name np -Value $($env:windir + '\system32\notepad.exe')
Set-Alias -Name npp -Value $($env:ProgramFiles + '\Notepad++\notepad++.exe')
Set-Alias -Name edge -Value $($env:LOCALAPPDATA + '\Microsoft\*\MicrosoftEdge.exe')
Set-Alias -Name chrome -Value $($env:ProgramFiles + '\Google\Chrome\Application\chrome.exe')
Set-Alias -Name fox -Value $($env:ProgramFiles + '\Firefox Developer Edition\firefox.exe')
Set-Alias -Name code -Value $($env:LOCALAPPDATA + '\Programs\Microsoft VS Code\Code.exe')
Set-Alias -Name wt -Value $($env:LOCALAPPDATA + '\Microsoft\WindowsApps\wt.exe')

#############
# FUNCTIONS #
############# 
function fnHistory{
	Get-History | Foreach-Object {$_.CommandLine } > $($env:HOMEDRIVE + '\Temp\script.ps1')
	notepad $($env:HOMEDRIVE + '\Temp\script.ps1')
}
function browseFox{
	$($env:ProgramFiles + '\Firefox Developer Edition\firefox.exe') + 'https://www.google.com/search?client=firefox-b-1-d&q=boat'
}

#################
# PROMPT-THEMES #
#################
#Set-PoshPrompt -Theme blue-owl
#Set-PoshPrompt -Theme ys
#Set-PoshPrompt -Theme powerlevel10k_rainbow
function prompt{
	$host.UI.RawUI.WindowTitle = "$(Get-Location)"
	# The at sign creates an array in case only one history item exists.
	
	$lastCommand = @(Get-History -Count 1)
	if($lastCommand){	
		$suggestions = @(Get-AliasSuggestion $lastCommand.CommandLine)
		$parameterAliases = @(Get-ParameterAlias $lastCommand.CommandLine) 
		$lastItem = $lastCommand[$lastCommand.Count - 1]
		$lastId = $lastItem.Id
		$Id = $lastId + 1
	}
	Write-Host ┏━ -ForegroundColor Cyan -NoNewLine
	Write-Host "(" -ForegroundColor DarkBlue -NoNewLine
	Write-Host "$(Get-Date -Format FileDate)" -ForegroundColor Green -NoNewLine
	Write-Host ")" -ForegroundColor DarkBlue -NoNewLine
	Write-Host ━━ -ForegroundColor Cyan -NoNewLine
	Write-Host "<<" -ForegroundColor DarkBlue -NoNewLine
	Write-Host 👾 -ForegroundColor Cyan -NoNewLine
	Write-Host ">>" -ForegroundColor DarkBlue -NoNewLine
	Write-Host ━ -ForegroundColor Cyan -NoNewLine
	Write-Host "["-ForegroundColor DarkBlue -NoNewLine
	Write-Host "$(Split-Path -Path $pwd -Leaf -Resolve)" -ForegroundColor Green -NoNewLine
	Write-Host "]"-ForegroundColor DarkBlue -NoNewLine
	Write-Host ""
	Write-Host ┃ -ForegroundColor Cyan
	if($Id){
		Write-Host "┗━━" -ForegroundColor Cyan -NoNewLine
		Write-Host "🔢 $Id 💲" -ForegroundColor Green -NoNewLine
	}

	else{
		Write-Host "┗━━" -ForegroundColor Cyan -NoNewLine
		Write-Host "🔢 💲" -ForegroundColor Green -NoNewLine
	}
	Write-Host "  " -NoNewLine
	"`b"
	""
	foreach($aliasSuggestion in $suggestions){
		Write-Host "$aliasSuggestion" -ForegroundColor Yellow
	}
	foreach($p in $parameterAliases){
		Write-Host "$p" -ForegroundColor Yellow
	}
}
