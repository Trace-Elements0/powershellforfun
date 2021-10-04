# powershellforfun
An example of what this profile should look like

![Example](/example.jpg)

## About the examples
The profile's main function is prompt and that's what it used to generate the nice looking ligatures you see in the photo. If you're able to use it without installing any powershell modules(because you have the required modules installed) all you'll need is the 3 powershell scripts that I got from [Lee Holmes' PowerShell Cookbook]( https://www.amazon.com/PowerShell-Cookbook-Scripting-Ubiquitous-Object-Based/dp/109810160X/) I can't say enough good things about it. I've had my fair share of fist fights trying to get my windows terminal profile to look just the way I want it to but was never able to until I picked this book up. Lee's scripts give PowerShell the ability to suggest alias names for cmdlets and their paramters.

## Apps Needed
[Windows Terminal](https://www.microsoft.com/en-us/p/windows-terminal/9n0dx20hk701#activetab=pivot:overviewtab) is preferred but no necessary, and I also recommend using the new
[PowerShell](https://docs.microsoft.com/en-us/powershell/scripting/install/installing-powershell-core-on-windows?view=powershell-7.1)
, lastly Git is needed but that should be installed.
## Font I use
[Nerd Font](https://github.com/ryanoasis/nerd-fonts) I've linked NerdFonts, the font I use is Agave Nerd Fonts
## PowerShell Modules
Once PowerShell is installed and you have Windows Terminal open you'll need to install these Modules. 
```
Install-Module posh-git -Scope CurrentUser -Confirm:$false
Install-Module oh-my-posh -Scope CurrentUser -RequiredVersion 2.0.412 -Confirm:$false
Install-Module Terminal-Icons -Scope CurrentUser -Confirm:$false
Install-Module PSReadline -Scope CurrentUser -AllowPrerelease -Force
```
"-Scope CurrentUser" just tells PowerShell to only install these modules for the current user.
The current user is whoever is logged in right now. That concept was kind of tricky to understand for me so I felt I should explain.

When I first tried to install these I had to install them from an elevated session(PowerShell talk for: Open Start-> Search for PowerShell by typing "PowerShell"-> When it's visible R.Click->Select Open as administrator).
## PowerShell Profile
Download and save all the ps1 files except profile.ps1. Save them to folder named 'Temp' in your C drive. Don't have one?
run this in Windows Terminal
```
If(!(Test-Path $profile))
{
	New-Item -ItemType File -Force -Path $profile
}
```
This tests if a path to an existing profile exists if it doesn't it makes one. You can then open your profile in notepad
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
