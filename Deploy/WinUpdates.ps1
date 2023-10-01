# Loop Windows Updates until current, then perform cleanup and SysPrep

<# 
User Variable Definitions
$TempPath - Location where files are stored during install. e.g. C:\Temp
$WSUSEnable - Enables use of WSUS for Windows updates. Value 1 or 0
#>
$TempPath = ""
$WSUSEnable = 1

# Static Variable
$Update = Get-WindowsUpdate

if ($Update -ne $null){
    Write-Host "Performing Additional Windows Updates"
    Write-Host "-------------------------------------"
    Install-WindowsUpdate -MicrosoftUpdate -AcceptAll -AutoReboot
} else {
    # Peform Post-Install Cleanup
    Write-Host "Cleaning Up..."
    Write-Host "--------------"

    # Purge Installers
    Remove-Item $TempPath -Recurse
    
    # Reset PS Execution Policy
    Set-ExecutionPolicy -ExecutionPolicy Restricted -Force
    
    # Re-Enable UAC
    $path = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System"
    New-ItemProperty -Path $path -Name 'EnableLUA' -Value 1 -PropertyType DWORD -Force | Out-Null

    # Purge WSUS Config
    if ($WSUSEnable -eq 1){
        $WSUSRoot = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate"
        Remove-Item -Path $WSUSRoot -Recurse
    }
        
    # Perform SysPrep for OOBE
    $sysprep = 'C:\Windows\System32\Sysprep\Sysprep.exe'
    $arg = '/generalize /oobe /reboot /quiet'
    Invoke-Command {param($sysprep,$arg) Start-Process -FilePath $sysprep -ArgumentList $arg} -ArgumentList $sysprep,$arg
    
}