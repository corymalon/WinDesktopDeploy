# WinDesktopDeploy
Automating Bare Metal Windows Deployments.
The [Wiki](https://github.com/corymalon/WinDesktopDeploy/wiki) contains more detailed information on prepping your environment. 

# Technology Stack
- Windows Server 2022 21H2
  - Windows Deployment Server
  - Windows Server Update Services
  - Windows System Image Manager
- Windows 10 Pro ISO

# Getting Started
You will need to have Windows Deployment Server setup. WSUS is optional, but highly recommended to reduce download times for Windows Updates.

## Configuring Your Environment
There are parameters that you will need to set across different areas. This is a high level overview of those changes.

### SWPrep.ps1
You will need to define the `$Destination` variable. This should be a mapped network path where you intend to deploy software from. (e.g. `M:\Deploy`)

### Setup.ps1
You will need to define the following variables.

 - `$TempPath` - Location where files are stored during install. e.g. `C:\Temp`
 - `$SourcePath` - Mapped drive where media is located. e.g. `M:\Deploy`
 - `$WSUSEnable` - Enables use of WSUS for Windows updates. Value `1` or `0`

If you are using WSUS you will additionally need to define these variables.

- `$WSUSProt` - HTTP or HTTPS define as `http://` or `https://`
- `$WSUS` - IP or hostname of your WSUS server
- `$WSUSPort` - Port number for WSUS. Default `:8530`

### WinUpdates.ps1
You will need to define the following variables.

- `$TempPath` - Location where files are stored during install. e.g. `C:\Temp`
- `$WSUSEnable` - Enables use of WSUS for Windows updates. Value `1` or `0`

## Demo
This is a video clip of what the end result looks like.
[![](https://markdown-videos-api.jorgenkh.no/youtube/CxkScz8vrnM)](https://youtu.be/CxkScz8vrnM)