#Remember to Set-ExecutionPolicy AllSigned
#Hiding unwanted taskbar elements
Set-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Search -Name SearchBoxTaskbarMode -Value 0 -Type DWord -Force
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Feeds" -Name "ShellFeedsTaskbarViewMode" -Value 2
#Does not add 'Shortcut' to new shortcuts
REM Does not add "- Shortcut" to new shortcuts
REG ADD "HKU\%1\Software\Microsoft\Windows\CurrentVersion\Explorer" /v "link" /t REG_BINARY /d 00000000 /f
#Stops explorer to load changes
Stop-Process -name explorer -force
#Installing packages
Write-Host "Basic profile for Windows 10"
(
    "Mozilla.Firefox",
    "Google.Chrome",
    "CodecGuide.K-LiteCodecPackMega",
    "Transmission.Transmission",
    "FileConverter.FileConverter",
    "7zip.7zip",
    "OBSProject.OBSStudio",
    #"Oracle.JavaRuntimeEnvironment",
    "KeePassXCTeam.KeePassXC",
    "Mozilla.Thunderbird",
    "AnyDeskSoftwareGmbH.AnyDes",
    "Telegram.TelegramDesktop",
    "Rufus.Rufus",
    "Zoom.Zoom",
    "Microsoft.Skype",
    "TeamViewer.TeamViewer"#,
    #"Valve.Steam"
) | foreach {winget install -e --id $_}
#Setting up a new hostname
Write-Host "Please, provide a name for your computer:"
ForegroundColor Green
$ComputerName = Read-Host
Rename-Computer -NewName "$ComputerName"
#Starts Chris Titus' script
iex ((New-Object System.Net.WebClient).DownloadString('https://git.io/JJ8R4'))