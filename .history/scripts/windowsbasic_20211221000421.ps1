Set-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Search -Name SearchBoxTaskbarMode -Value 0 -Type DWord -Force
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Feeds" -Name "ShellFeedsTaskbarViewMode" -Value 2

REM Does not add "- Shortcut" to new shortcuts
REG ADD "HKU\%1\Software\Microsoft\Windows\CurrentVersion\Explorer" /v "link" /t REG_BINARY /d 00000000 /f


Stop-Process -name explorer -force

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
    #"Valve.Steam"
) | foreach {winget install -e --id $_}
iex ((New-Object System.Net.WebClient).DownloadString('https://git.io/JJ8R4'))

Rename-Computer -NewName ""