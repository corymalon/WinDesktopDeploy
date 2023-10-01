# Unattended Install File Modifications
1. You will need to move the `./Unattend.xml` file to `%PATH%\RemoteInstall\WdsClientUnattend` (e.g. `C:\RemoteInstall\WdsClientUnattend`) on your WDS server.
2. You will need to make the following modifications using Windows System Image Manager that are specific to your environment.

### 1 windowsPE -> amd64_Microsoft-Windows-Setup_neutral -> WindowsDeploymentServices -> Login -> Credentials
Specify the following values:
- `Domain` - Domain/Workgroup of WDS server
- `Password` - Password of admin of WDS server
- `Username` - Username of admin of WDS server
``` xml
            <WindowsDeploymentServices>
                <Login>
                    <Credentials>
                        <Domain></Domain>
                        <Password></Password>
                        <Username></Username>
                    </Credentials>
                </Login>
```

### 1 windowsPE -> amd64_Microsoft-Windows-Setup_neutral -> WindowsDeploymentServices -> Image Selection -> InstallImage
Specify the following values defined in Windows Deployment Server:
- `ImageGroup` - (e.g. Win10)
- `ImageName` - (e.g. Windows10Pro)
- `Filename` - (e.g. install-(2).wim)
``` xml
            <WindowsDeploymentServices>
                    <InstallImage>
                        <ImageGroup></ImageGroup>
                        <ImageName></ImageName>
                        <Filename></Filename>
                    </InstallImage>
```


### 4 specialize -> amd64_Microsoft-Windows-IE-InternetExplorer_neutral
Specify the following values:
- `LocalIntranetSites` - Specify wildcard subnet of local network to prevent issues with file transfers using IP addresses. (e.g. 192.168.1.*)
``` xml
   <settings pass="specialize">
        <component name="Microsoft-Windows-IE-InternetExplorer" processorArchitecture="amd64" publicKeyToken="31bf3856ad364e35" language="neutral" versionScope="nonSxS" xmlns:wcm="http://schemas.microsoft.com/WMIConfig/2002/State" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
            <LocalIntranetSites></LocalIntranetSites>
        </component>
```

### 4 specialize -> amd64_Microsoft-Shell-Setup_neutral
Specify the following values:
- `ProductKey` - Your Windows 10 Pro Product Key
``` xml
<settings pass="specialize">
        <component name="Microsoft-Windows-Shell-Setup" processorArchitecture="amd64" publicKeyToken="31bf3856ad364e35" language="neutral" versionScope="nonSxS" xmlns:wcm="http://schemas.microsoft.com/WMIConfig/2002/State" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
            <ProductKey></ProductKey>
        </component>
```

### 7 oobeSystem -> amd64_Microsoft-Shell-Setup_neutral -> AutoLogin
Specify the following values:
- `Domain` - Use WORKGROUP
- `Username` - Username of account to use for setting up the machine
- `Password` - Specify the password for this account
``` xml
<settings pass="oobeSystem">
            <AutoLogon>
                <Password>
                    <Value></Value>
                    <PlainText>false</PlainText>
                </Password>
                <Enabled>true</Enabled>
                <LogonCount>5</LogonCount>
                <Username></Username>
                <Domain></Domain>
            </AutoLogon>
```

### 7 oobeSystem -> amd64_Microsoft-Shell-Setup_neutral -> FirstLogonCommands -> SynchronousCommand\[Order="1"]
Specify the following values:
- `CommandLine` - This is used to connect to network deployment share (e.g. `net use m: \\x.x.x.x\share /persistent:yes /user:username password`)
``` xml
<settings pass="oobeSystem">
            <FirstLogonCommands>
                <SynchronousCommand wcm:action="add">
                    <CommandLine></CommandLine>
                    <Order>1</Order>
                    <RequiresUserInput>false</RequiresUserInput>
                </SynchronousCommand>
```

### 7 oobeSystem -> amd64_Microsoft-Shell-Setup_neutral -> FirstLogonCommands -> SynchronousCommand\[Order="3"]
Specify the following values:
- `CommandLine` - This will execute the `Setup.ps1` script (e.g. `powershell M:\Deploy\Setup.ps1`)
``` xml
<settings pass="oobeSystem">
            <FirstLogonCommands>
                <SynchronousCommand wcm:action="add">
                    <CommandLine></CommandLine>
                    <Order>3</Order>
                    <RequiresUserInput>false</RequiresUserInput>
                </SynchronousCommand>
```

### 7 oobeSystem -> amd64_Microsoft-Shell-Setup_neutral -> UserAccounts -> LocalAccounts -> LocalAccount
Specify the following values:
- `DisplayName` - Display name of account to use for setting up the machine (e.g. pcsetup)
- `Group` - This should be set to `Administrators`
- `Name` - Username of account to use for setting up the machine (e.g. pcsetup)
- `Password` - Specify a password for this account
``` xml
<settings pass="oobeSystem">
            <UserAccounts>
                <LocalAccounts>
                    <LocalAccount wcm:action="add">
                        <Password>
                            <Value></Value>
                            <PlainText>false</PlainText>
                        </Password>
                        <DisplayName></DisplayName>
                        <Group></Group>
                        <Name></Name>
                    </LocalAccount>
                </LocalAccounts>
            </UserAccounts>
```