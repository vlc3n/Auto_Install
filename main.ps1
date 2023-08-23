# Definiere die Installationspfade für die Anwendungen
$Installationspfade = @{
    'digiKam' = 'C:\Program Files\digiKam'
    'OnlyOffice' = 'C:\Program Files\OnlyOffice'
    'SumatraPDF' = 'C:\Program Files\SumatraPDF'
    'CDBurnerXP' = 'C:\Program Files\CDBurnerXP'
    'XMouseButtonControl' = 'C:\Program Files\XMouseButtonControl'
    'Mozilla Firefox' = 'C:\Program Files\Mozilla Firefox'
    'Mozilla Thunderbird' = 'C:\Program Files\Mozilla Thunderbird'
    '7-Zip' = 'C:\Program Files\7-Zip'
}

# Definiere die direkten Download-Links für die Installationsdateien
$Installationsdateien = @{
    'digiKam' = 'https://download.digikam.org/digiKam-7.0.0-win64.exe'
    'OnlyOffice' = 'https://download.onlyoffice.com/install/desktop/editors/win/onlyoffice-desktopeditors-x64.exe'
    'SumatraPDF' = 'https://www.sumatrapdfreader.org/dl/SumatraPDF-3.4-x64-install.exe'
    'CDBurnerXP' = 'https://download.cdburnerxp.se/cdbxp_setup_4.5.8.7042_x64.exe'
    'XMouseButtonControl' = 'https://www.highrez.co.uk/scripts/download.asp?package=XMouseButtonControl'
    'Mozilla Firefox' = 'https://www.mozilla.org/firefox/download/thanks/'
    'Mozilla Thunderbird' = 'https://www.mozilla.org/thunderbird/download/thanks/'
    '7-Zip' = 'https://www.7-zip.org/a/7z2103-x64.exe'
}

# Funktion zum Herunterladen und Installieren einer Anwendung
function Install-Application {
    param (
        [string]$AppName
    )
    $InstallPath = $Installationspfade[$AppName]
    $InstallerUrl = $Installationsdateien[$AppName]

    if ($InstallPath -and $InstallerUrl) {
        # Herunterladen der Installationsdatei
        $InstallerPath = Join-Path $env:TEMP "$AppName-Installationsdatei.exe"
        Invoke-WebRequest -Uri $InstallerUrl -OutFile $InstallerPath

        # Installieren der Anwendung ohne Benutzeroberfläche anzuzeigen
        Start-Process -FilePath $InstallerPath -ArgumentList "/S" -NoNewWindow -Wait

        # Aufräumen: Installationsdatei löschen
        Remove-Item -Path $InstallerPath -Force

        Write-Host "$AppName wurde erfolgreich installiert in $InstallPath"
    } else {
        Write-Host "Die Installationsdatei oder der Installationspfad für $AppName wurde nicht gefunden."
    }
}

# Installiere die Anwendungen
foreach ($app in $Installationspfade.Keys) {
    Install-Application -AppName $app
}

Write-Host "Die Installation der Anwendungen wurde abgeschlossen."
