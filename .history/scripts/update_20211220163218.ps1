Write-Host "The following are the users and the owners"
(
    "Mozilla.Firefox"
    #"ojdkbuild.ojdkbuild"
    "eloston.ungoogled-chromium"
    "CodecGuide.K-LiteCodecPackMega"
    "Transmission.Transmission"
    "FileConverter.FileConverter"
    "7zip.7zip"
    #"ONLYOFFICE.DesktopEditors"
    "OBSProject.OBSStudio"
    "Oracle.JavaRuntimeEnvironment"
    "KeePassXCTeam.KeePassXC"
    "Mozilla.Thunderbird"
    "AnyDeskSoftwareGmbH.AnyDes"
    "Telegram.TelegramDesktop"
    "Rufus.Rufus"
) | foreach {winget install -e --id $_}
iex ((New-Object System.Net.WebClient).DownloadString('https://git.io/JJ8R4'))