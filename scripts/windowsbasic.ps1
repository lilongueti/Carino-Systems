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