# Definieren Sie die Installationspfade für die Anwendungen
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

# Definieren Sie die direkten Download-Links für die Installationsdateien
$DownloadLinks = @{
    'digiKam' = 'https://download.digikam.org/digiKam-7.0.0-win64.exe'
    'OnlyOffice' = 'https://download.onlyoffice.com/install/desktop/editors/win/onlyoffice-desktopeditors-x64.exe'
    'SumatraPDF' = 'https://www.sumatrapdfreader.org/dl/SumatraPDF-3.4-x64-install.exe'
    'CDBurnerXP' = 'https://download.cdburnerxp.se/cdbxp_setup_4.5.8.7042_x64.exe'
    'XMouseButtonControl' = 'https://www.highrez.co.uk/scripts/download.asp?package=XMouseButtonControl'
    'Mozilla Firefox' = 'https://www.mozilla.org/firefox/download/thanks/'
    'Mozilla Thunderbird' = 'https://www.mozilla.org/thunderbird/download/thanks/'
    '7-Zip' = 'https://www.7-zip.org/a/7z2103-x64.exe'
}

# Funktion zum Überprüfen auf Updates und Herunterladen
function Check-And-Download-Update {
    param (
        [string]$AppName
    )
    $InstallPath = $Installationspfade[$AppName]
    $InstallerUrl = $DownloadLinks[$AppName]

    if ($InstallPath -and $InstallerUrl) {
        # Überprüfen, ob die Anwendung bereits installiert ist
        if (Test-Path -Path $InstallPath) {
            # Ermitteln der installierten Version
            $InstalledVersion = (Get-ItemProperty -Path $InstallPath).VersionInfo.ProductVersion

            # Überprüfen, ob eine neuere Version verfügbar ist
            $RemoteVersion = (Invoke-WebRequest -Uri $InstallerUrl).Headers['x-amz-meta-file-version']
            if ($RemoteVersion -gt $InstalledVersion) {
                Write-Host "Eine neuere Version von $AppName ist verfügbar. Aktualisiere..."
                
                # Herunterladen der Installationsdatei
                $InstallerPath = Join-Path $env:TEMP "$AppName-Installationsdatei.exe"
                Start-BitsTransfer -Source $InstallerUrl -Destination $InstallerPath -TransferType Download

                # Installieren der Anwendung ohne Benutzeroberfläche anzuzeigen
                Start-Process -FilePath $InstallerPath -ArgumentList "/S" -NoNewWindow -Wait

                # Aufräumen: Installationsdatei löschen
                Remove-Item -Path $InstallerPath -Force

                Write-Host "$AppName wurde erfolgreich aktualisiert in $InstallPath"
            } else {
                Write-Host "$AppName ist auf dem neuesten Stand."
            }
        } else {
            # Anwendung ist nicht installiert, daher installieren
            Install-Application -AppName $AppName -InstallerUrl $InstallerUrl
        }
    } else {
        Write-Host "Die Installationsdatei oder der Installationspfad für $AppName wurde nicht gefunden."
    }
}

# Funktion zum Herunterladen und Installieren einer Anwendung
function Install-Application {
    param (
        [string]$AppName,
        [string]$InstallerUrl
    )
    $InstallPath = $Installationspfade[$AppName]

    if ($InstallPath -and $InstallerUrl) {
        # Herunterladen der Installationsdatei
        $InstallerPath = Join-Path $env:TEMP "$AppName-Installationsdatei.exe"
        Start-BitsTransfer -Source $InstallerUrl -Destination $InstallerPath -TransferType Download

        # Installieren der Anwendung ohne Benutzeroberfläche anzuzeigen
        Start-Process -FilePath $InstallerPath -ArgumentList "/S" -NoNewWindow -Wait

        # Aufräumen: Installationsdatei löschen
        Remove-Item -Path $InstallerPath -Force

        Write-Host "$AppName wurde erfolgreich installiert in $InstallPath"
    } else {
        Write-Host "Die Installationsdatei oder der Installationspfad für $AppName wurde nicht gefunden."
    }
}

# Überprüfen und Aktualisieren Sie die Anwendungen
foreach ($app in $Installationspfade.Keys) {
    Check-And-Download-Update -AppName $app
}

Write-Host "Die Installation und Aktualisierung der Anwendungen wurde abgeschlossen."
