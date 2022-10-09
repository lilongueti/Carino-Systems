#Remember to Set-ExecutionPolicy Bypass
#Dark Theme
Set-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize -Name AppsUseLightTheme -Value 0
#Hiding unwanted taskbar elements
Set-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Search -Name SearchBoxTaskbarMode -Value 0 -Type DWord -Force
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Feeds" -Name "ShellFeedsTaskbarViewMode" -Value 2
#Does not add 'Shortcut' to new shortcuts
REM Does not add "- Shortcut" to new shortcuts
REG ADD "HKU\%1\Software\Microsoft\Windows\CurrentVersion\Explorer" /v "link" /t REG_BINARY /d 00000000 /f
#Stops explorer to load changes
Stop-Process -name explorer -force
#Installing WSL distributions
#wsl --install -d Ubuntu
#wsl --install -d Debian
#Installing packages
Write-Host "Basic profile for Windows 10"
(
    "Mozilla.Firefox",
    "Cisco.WebexTeams",
    "Cisco.Jabber",
    "Google.Chrome",
    "CodecGuide.K-LiteCodecPack.Mega",
    "Transmission.Transmission",
    "AdrienAllard.FileConverter",
    "Surfshark.SurfsharkVPN",
    "7zip.7zip",
    "Microsoft.VisualStudioCode",
    "SonicWALL.GlobalVPN",
    "OBSProject.OBSStudio",
    "Python.Python.3",
    #"Oracle.JavaRuntimeEnvironment",
    "KeePassXCTeam.KeePassXC",
    "Mozilla.Thunderbird",
    "AnyDeskSoftwareGmbH.AnyDesk",
    "Telegram.TelegramDesktop",
    "Rufus.Rufus",
    #"Zoom.Zoom",
    #"Microsoft.Skype",
    "TeamViewer.TeamViewer",
    "Valve.Steam",
    "Buttercup.Buttercup"
) | foreach {winget install -e --id $_}
#Setting up a new hostname
Write-Host "Please, provide a name for your computer:"
ForegroundColor Green
$ComputerName = Read-Host
Rename-Computer -NewName "$ComputerName"
#Starts Chris Titus' script
iwr -useb https://christitus.com/win | iex