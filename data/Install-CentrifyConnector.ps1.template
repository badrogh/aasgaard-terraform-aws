param
(
	[String]$PackageURL,
	[String]$TenantURL,
	[String]$RegCode	
)
# Run Centrify Connector Installation
Write-Output "####################################################"
Write-Output "# Centrify Connector Installation and Registration #"
Write-Output "####################################################"
Write-Output

# Prepare temp folder and start transcript
if (!(Test-Path "C:\Temp\Centrify\"))
{
	New-Item "C:\Temp\Centrify\" | Out-Null
}
Start-Transcript C:\Temp\Centrify\centrify_install.log

Write-Output "> Downloading Centrify Connector Installer package"
Invoke-WebRequest -Uri $PackageURL -OutFile C:\temp\Centrify\Centrify-Connector-Installer.zip

Write-Output "> Extracting package"
Add-Type -AssemblyName System.IO.Compression.FileSystem
[System.IO.Compression.ZipFile]::ExtractToDirectory("C:\temp\Centrify\Centrify-Connector-Installer.zip", "C:\temp\Centrify\")
$Installer = (Get-ChildItem -Path C:\Temp\Centrify\*.exe -File).FullName

Write-Output "> Running Centrify Connector Installer"
Invoke-Expression "$Installer /silent /norestart"

$t = 1
while (!(Test-Path "C:\Program Files\Centrify\Centrify Connector\Centrify.Cloud.ProxyRegisterCli.exe")) 
{ 
	Write-Output ("Waiting for installation to finish... [{0:m\mss\s} elapsed]" -f [TimeSpan]::FromSeconds(10 * $t++))
	Start-Sleep -Seconds 10 
}

Write-Output "> Registering Centrify Connector against ${tenant_url}"
& 'C:\Program Files\Centrify\Centrify Connector\Centrify.Cloud.ProxyRegisterCli.exe'  url=$TenantURL regcode=$RegCode

Write-Output "> Starting Centrify Connector service"
Start-Service adproxy

Stop-Transcript
