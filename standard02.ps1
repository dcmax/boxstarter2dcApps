# configurazione standard per PC

# Boxstarter options
$Boxstarter.RebootOk=$true # Allow reboots?
$Boxstarter.NoPassword=$false # Is this a machine with no login password?
$Boxstarter.AutoLogin=$true # Save my password securely and auto-login after a reboot
$env:ChocolateyAllowEmptyChecksums=$true

# Basic setup
Write-Host "configuro execution policy" 
Update-ExecutionPolicy -remotesigned

Disable-UAC

Write-Host "Attivo MicrosoftUpdate"
Enable-MicrosoftUpdate

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

Write-Host "Install WindowsUpdate"
Install-WindowsUpdate -AcceptEula -GetUpdatesFromMS

start-sleep 30

choco install 7zip.install -y 
choco install googlechrome -y
choco install firefox -y
choco install adobereader -y
choco install notepadplusplus.install -y

Set-windowsExplorerOptions  -showFileExtensions -EnableShowFullPathInTitleBar -EnableOpenFileExplorerToQuickAccess -EnableShowRecentFilesInQuickAccess -EnableShowFrequentFoldersInQuickAccess -EnableExpandToOpenFolder -EnableShowRibbon

DISM /Online /NoRestart /Enable-Feature:TelnetClient

Enable-RemoteDesktop

# Update Windows and reboot if necessary
start-sleep 30

if (Test-PendingReboot) { Invoke-Reboot }

start-sleep 10

Enable-UAC

Write-Host -ForegroundColor:Green "Installazione econfigurazione completata!" 
start-sleep 30


