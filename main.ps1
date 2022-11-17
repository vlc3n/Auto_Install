# Scriptausfuehrung fuer diese Sitzung erlauben
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
write("Skriptausfuehrung aktiviert")

write("Lade Scoop herunter...")
# Scoop runterladen
irm get.scoop.sh | iex
scoop install git

# Scoop "Extra" Bucket installieren fuer weitere Pakete
write("Installiere Bucket Extra")
scoop bucket add extras

# Programmpakete installieren
scoop install digikam
scoop install onlyoffice-desktopeditors
scoop install sumatrapdf
scoop install cdburnerxp
scoop install xmousebuttoncontrol
scoop install firefox
scoop install thunderbird
scoop install 7zip

# Scoop  deinstallieren
rmdir C:\Users\$env:UserName\scoop\
write("Scoop wurde wieder entfernt.")

PAUSE
