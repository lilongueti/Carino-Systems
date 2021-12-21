Write-Host "Basic profile for Windows 10"
(
    "Mozilla.Firefox",
    "eloston.ungoogled-chromium",
    "CodecGuide.K-LiteCodecPackMega",
    "Transmission.Transmission",
    "FileConverter.FileConverter",
    "7zip.7zip",
    "OBSProject.OBSStudio",
    "Oracle.JavaRuntimeEnvironment",
    "KeePassXCTeam.KeePassXC",
    "Mozilla.Thunderbird",
    "AnyDeskSoftwareGmbH.AnyDes",
    "Telegram.TelegramDesktop",
    "Rufus.Rufus"
) | foreach {winget install -e --id $_}
iex ((New-Object System.Net.WebClient).DownloadString('https://git.io/JJ8R4'))