# Downloads and prepares software and scripts as defined in this repository.

<# 
Variable definitions - Set appropriate locations for your environment. 
Typically this would be the network share from where you intend to deploy the software from.
You will specify this deployment location in the Setup.ps1 script.
#>

# Use $Destination for the path where files where be downloaded. e.g. M:\Deploy
$Destination = ""

# Use $OfficeCFG to specify where the Configuration.xml file is located from this repository
$OfficeCFG = "$Destination\Configuration.xml"

# Software URI Locations
$Office = "https://download.microsoft.com/download/2/7/A/27AF1BE6-DD20-4CB4-B154-EBAB8A7D4A7E/officedeploymenttool_16731-20290.exe"
$NPP = "https://github.com/notepad-plus-plus/notepad-plus-plus/releases/download/v8.5.7/npp.8.5.7.Installer.x64.exe"
$Adobe = "https://ardownload2.adobe.com/pub/adobe/reader/win/AcrobatDC/2300620320/AcroRdrDC2300620320_en_US.exe"
$VLC = "https://ziply.mm.fcix.net/videolan-ftp/vlc/3.0.18/win64/vlc-3.0.18-win64.exe"
$FireFox = "https://download-installer.cdn.mozilla.net/pub/firefox/releases/118.0.1/win64/en-US/Firefox%20Setup%20118.0.1.msi"
$Chrome = "https://dl.google.com/tag/s/appguid%3D%7B8A69D345-D564-463C-AFF1-A69D9E530F96%7D%26iid%3D%7B1759E40C-1AF5-A9AA-C009-6853100CF221%7D%26lang%3Den%26browser%3D4%26usagestats%3D0%26appname%3DGoogle%2520Chrome%26needsadmin%3Dtrue%26ap%3Dx64-stable-statsdef_0%26brand%3DGCEA/dl/chrome/install/googlechromestandaloneenterprise64.msi"

# Create $Destination folder if it does not exist
if (!(Test-Path $Destination -PathType Container)) {
    New-Item -ItemType Directory -Force -Path $Destination
}

# Create array of URIs to download
$Packages = @($Office,$NPP,$Adobe,$VLC,$FireFox,$Chrome)

# Perform downloads
foreach ($Package in $Packages){
    Start-BitsTransfer -Source $Package -Destination $Destination
}

# Extract O365 Installer
Start-Process -FilePath "$Destination\officedeploymenttool_16731-20290.exe" -ArgumentList "/extract:$Destination\Office365 /quiet" -Wait

# Download O365 Apps
Start-Process -FilePath "$Destination\Office365\setup.exe" -ArgumentList "/download $OfficeCFG" -Wait

# Copy items from the repository to $Destination for deployment via Setup.ps1.
Copy-Item -Path ..\Deploy\Setup.ps1 -Destination $Destination
Copy-Item -Path ..\Deploy\WinUpdates.bat -Destination $Destination
Copy-Item -Path ..\Deploy\WinUpdates.ps1 -Destination $Destination
Copy-Item -Path ..\OfficeCFG\Office365\Configuration.xml -Destination $Destination