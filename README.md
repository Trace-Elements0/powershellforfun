# powershellforfun
An example of what this profile should look like

![Example](/example.jpg)

As well as what it can do
![Example1](/powershellforfun.gif)

## About the examples
The profile's main function is prompt and that's what it used to generate the nice looking ligatures you see in the photo. If you're able to use it without installing any powershell modules(because you have the required modules installed) all you'll need is the 3 powershell scripts that I got from [Lee Holmes' PowerShell Cookbook]( https://www.amazon.com/PowerShell-Cookbook-Scripting-Ubiquitous-Object-Based/dp/109810160X/) I can't say enough good things about it. I've had my fair share of fist fights trying to get my windows terminal profile to look just the way I want it to but was never able to until I picked this book up. Lee's scripts give PowerShell the ability to suggest alias names for cmdlets and their paramters.

## Apps Needed
[Windows Terminal](https://www.microsoft.com/en-us/p/windows-terminal/9n0dx20hk701#activetab=pivot:overviewtab) is preferred but no necessary, and I also recommend using the new
[PowerShell](https://docs.microsoft.com/en-us/powershell/scripting/install/installing-powershell-core-on-windows?view=powershell-7.1)
, lastly Git is needed but that should be installed.
## Font I use
[Nerd Font](https://github.com/ryanoasis/nerd-fonts) I've linked NerdFonts, the font I use is Agave Nerd Fonts

## Installation & Configuration
Can be manually done by installing the powershell modules, creating the profile and adding the new directory to your path or run install-dependencies.ps1
## PowerShell Modules
Once PowerShell is installed and you have Windows Terminal open you'll need to install these Modules. 
```
Install-Module posh-git -Scope CurrentUser -Confirm:$False -Force
Install-Module oh-my-posh -Scope CurrentUser -RequiredVersion 2.0.412 -Confirm:$False -Force
Install-Module PSReadline -Scope CurrentUser -AllowPrerelease -Confirm:$False -Force
Install-Module Terminal-Icons -Scope CurrentUser -Confirm:$False -Force
```
"-Scope CurrentUser" just tells PowerShell to only install these modules for the current user.
The current user is whoever is logged in right now. That concept was kind of tricky to understand for me so I felt I should explain.

When I first tried to install these I had to install them from an elevated session(PowerShell talk for: Open Start-> Search for PowerShell by typing "PowerShell"-> When it's visible R.Click->Select Open as administrator).
## Helper Scripts
Download and save all the ps1 files except profile.ps1 into a folder named 'Temp' in your C drive. Full path should be C\\:Temp. You can use the file explorer GUI or in powershell you can run
```
If(!(Test-Path $($env:HOMEDRIVE + '\Temp'))){
	New-Item -ItemType Directory -Path $env:HOMEDRIVE -Name "Temp"
}
```

Because we're going to use the helper scripts in our profile we need to make sure every session can find these scripts, so we need to add that new Temp directory to our path envirionment variable.
To read more about environment variables see [about_Environment_Variables](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_environment_variables?view=powershell-7.1).
You can add the path manually as is described [here](https://www.architectryan.com/2018/03/17/add-to-the-path-on-windows-10/) 
or again in powershell you could run:
```
#Get the users current path value
$CurrentValue = [Environment]::GetEnvironmentVariable("Path", "User")    
#Add the new path             
[Environment]::SetEnvironmentVariable("Path", $CurrentValue + [System.IO.Path]::PathSeparator + "C:\Temp", "User")

```
As a test you could run ```$Env:Path -Split ";"``` and your new directory should be listed. You can also then run ```Get-AliasSuggestion Get-Command```. If the scripts are saved in the directory and powershell is able to find them you should see ```Suggestion: An alias for Get-Command is gcm```
## PowerShell Profile
Now that our helper scripts are created we need to create our profile if it does not exist.
This next expression checks if a profile exists and if it does not it will create one for you.
```
If(!(Test-Path $profile))
{
	New-Item -ItemType File -Force -Path $profile
}
```
Now we can open our profile script, which is a .ps1 file, in notepad.
```
notepad $profile
```
copy and paste the contents of the profile.ps1 file. 
Lastly reload you profile
```
. $profile
```
At this point your windows terminal should look pretty cool but if not, I've linked the resources I used in the past to learn how to setup my powershell profile.
- https://www.youtube.com/watch?v=lu__oGZVT98&feature=emb_imp_woyt
- https://www.leeholmes.com
- https://www.networkadm.in/customize-pscmdprompt
- https://docs.microsoft.com/en-us/powershell/scripting/developer/module/installing-a-powershell-module?view=powershell-7.1
- https://ohmyposh.dev
- https://www.neolisk.blog/posts/2009-07-23-powershell-special-characters
