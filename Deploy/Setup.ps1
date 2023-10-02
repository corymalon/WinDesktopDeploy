<#
Name: Setup.ps1
Function:
    - Deploy standardized software
    - Deploy configuration scripts
    - Perform Windows Updates

Install Apps, Drivers, Windows Updates, SysPrep
Included Apps: Chrome, FireFox, VLC, Notepad++, Adobe Reader, O365
#>

<# 
User Variable Definitions
$TempPath - Location where files are stored during install. e.g. C:\Temp
$SourcePath - Mapped drive where media is located. e.g. M:\Deploy
$WSUSEnable - Enables use of WSUS for Windows updates. Value 1 or 0
$WSUSProt - HTTP or HTTPS define as http:// or https://
$WSUS - IP or hostname of your WSUS server
$WSUSPort - Port number for WSUS. Default :8530
#>

$TempPath = ""
$SourcePath = ""
$WSUSEnable = 1
$WSUSProt = "http://"
$WSUS = ""
$WSUSPort = ":8530"

# Set Software Executable Variables
$AdobeEXE = "AcroRdrDC2300620320_en_US.exe"
$NppEXE = "npp.8.5.7.Installer.x64.exe"
$VlcEXE = "vlc-3.0.18-win64.exe"
$FirefoxExe = "FirefoxSetup118.0.1.msi"
$ChromeEXE = "googlechromestandaloneenterprise64.msi"
$OfficeEXE = "setup.exe"

# Static Variables - DO NOT MODIFY if using Vanila script
$DeployPath = "$TempPath\$SourcePath\"
$StartupPath = [Environment]::GetFolderPath([Environment+SpecialFolder]::Startup)
$OfficeDIR = "Office\"
$OfficeCFG = "Configuration.xml"

# Create the Temp Directory
if (!(Test-Path $TempPath -PathType Container)) {
    New-Item -ItemType Directory -Force -Path $TempPath
}

Clear

# Copy Source Media 
Write-Host "Copying Installation Files Locally..."
Write-Host "-------------------------------------"
Copy-Item $SourcePath -Destination $TempPath -Recurse

Write-Host "Copy Complete."
Write-Host ""

# Install Software First
Write-Host "Installing Software"
Write-Host "-------------------"

# Deploy Manuals and Windows Update Script
Write-Host "Installing Windows Update Boot Script..."
Copy-Item "$DeployPath\WinUpdates.bat" -Destination $StartupPath
Copy-Item "$DeployPath\WinUpdates.ps1" -Destination $env:USERPROFILE\documents

# Install Adobe Reader
Write-Host "Installing Adobe Reader..."
Start-Process -FilePath "$DeployPath$AdobeExe" -ArgumentList "/sAll /rs /msi EULA_ACCEPT=YES" -Wait

# Install Notepad++
Write-Host "Installing Notepad++..."
Start-Process -FilePath "$DeployPath$NppEXE" -ArgumentList "/S" -Wait

# Install VLC
Write-Host "Installing VLC..."
Start-Process -FilePath "$DeployPath$VlcEXE" -ArgumentList "/L=1033 /S" -Wait

# Install FireFox
Write-Host "Installing Firefox..."
Start-Process msiexec -ArgumentList "/i $DeployPath$FirefoxEXE /q /norestart" -Wait

# Install Chrome
Write-Host "Installing Chrome..."
Start-Process msiexec -ArgumentList "/i $DeployPath$ChromeEXE /qn" -Wait

# Install Office 365
Write-Host "Installing Office 365..."
Start-Process -FilePath $DeployPath$OfficeDIR$OfficeEXE -ArgumentList "/configure $DeployPath$OfficeDIR$OfficeCFG" -Wait

# Perform Windows Updates
Write-Host ""
Write-Host "Performing Windows Updates"
Write-Host "--------------------------"

# Configure WSUS policy
if ($WSUSEnable -eq 1){
    $WSUSRoot = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate"
    $WSUSAURoot = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU"
    New-Item -Path $WSUSRoot
    New-Item -Path $WSUSAURoot
    New-ItemProperty -Path $WSUSRoot -Name 'SetProxyBehaviorForUpdateDetection' -Value 0 -PropertyType DWORD -Force | Out-Null
    New-ItemProperty -Path $WSUSRoot -Name 'UpdateServiceUrlAlternate' -PropertyType String -Force | Out-Null
    New-ItemProperty -Path $WSUSRoot -Name 'WUServer' -Value "$WSUSProt$WSUS$WSUSPort" -PropertyType String -Force | Out-Null
    New-ItemProperty -Path $WSUSRoot -Name 'WUStatusServer' -Value "$WSUSProt$WSUS$WSUSPort" -PropertyType String -Force | Out-Null
    New-ItemProperty -Path $WSUSAURoot -Name 'UseWUServer' -Value 1 -PropertyType DWORD -Force | Out-Null
}

# Install NuGet
Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force

# Install PSWindowsUpdate Module
Install-Module -Name PSWindowsUpdate -Force

# Execute Windows Updates
Install-WindowsUpdate -MicrosoftUpdate -AcceptAll -AutoReboot
