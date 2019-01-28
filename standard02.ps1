# configurazione standard per PC versione 3

# Boxstarter options
$Boxstarter.RebootOk=$true # Allow reboots?
$Boxstarter.NoPassword=$false # Is this a machine with no login password?
$Boxstarter.AutoLogin=$true # Save my password securely and auto-login after a reboot
$env:ChocolateyAllowEmptyChecksums=$true

# Basic setup
Write-Host "Configuro execution policy" 
Update-ExecutionPolicy -remotesigned

Disable-UAC


Write-Host "Aggiorno le impostazioni per windows update"
# Change Windows Updates to "Notify to schedule restart"
If (!(Test-Path "HKCU:\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings")) {
    New-Item -Path HKCU:\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings -Force | Out-Null
}
Set-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings -Name UxOption -Type DWord -Value 1
If (!(Test-Path "HKLM:\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings")) {
    New-Item -Path HKLM:\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings -Force | Out-Null
}
Set-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings -Name UxOption -Type DWord -Value 1

choco install 7zip.install -y  -verbose
choco install googlechrome -y -verbose
choco install firefox -y -verbose
choco install adobereader -y -verbose
choco install notepadplusplus.install -y -verbose



Set-windowsExplorerOptions  -showFileExtensions -EnableShowFullPathInTitleBar -EnableOpenFileExplorerToQuickAccess -EnableShowRecentFilesInQuickAccess -EnableShowFrequentFoldersInQuickAccess -EnableExpandToOpenFolder -EnableShowRibbon

DISM /Online /NoRestart /Enable-Feature:TelnetClient

Enable-RemoteDesktop

# Update Windows and reboot if necessary
start-sleep 30

Enable-UAC

Write-Host "Attivo MicrosoftUpdate"
Enable-MicrosoftUpdate

Write-Host "Installazione WindowsUpdate"
Install-WindowsUpdate -AcceptEula -GetUpdatesFromMS

start-sleep 30
if (Test-PendingReboot) { Invoke-Reboot }

start-sleep 10



Write-Host "Seconda fase installazione WindowsUpdate"
Install-WindowsUpdate -AcceptEula -GetUpdatesFromMS
start-sleep 10
if (Test-PendingReboot) { Invoke-Reboot }

Write-Host -ForegroundColor:Green "Installazione econfigurazione completata!" 
start-sleep 30


