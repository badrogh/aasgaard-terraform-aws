param
(
	[Parameter(Mandatory = $true)]
	[String]$PackageURL,

	[Parameter(Mandatory = $true)]
	[String]$TenantURL,

	[Parameter(Mandatory = $true)]
	[String]$RegCode,

	[Parameter(Mandatory = $false)]
	[String]$TempFolder = "C:\Windows\Temp\Centrify\"
)
# Prepare temp folder and start transcript
if (!(Test-Path $TempFolder))
{
	New-Item $TempFolder | Out-Null
}
Start-Transcript ("{0}centrify_install.log" -f $TempFolder)

# Centrify Connector Installation
Write-Output "####################################################"
Write-Output "# Centrify Connector Installation and Registration #"
Write-Output "####################################################"
Write-Output
Write-Output "> Downloading Centrify Connector Installer package..."
Invoke-WebRequest -Uri $PackageURL -OutFile ("{0}Centrify-Connector-Installer.zip" -f $TempFolder)

Write-Output "> Extracting package..."
Add-Type -AssemblyName System.IO.Compression.FileSystem
[System.IO.Compression.ZipFile]::ExtractToDirectory(("{0}Centrify-Connector-Installer.zip" -f $TempFolder, $TempFolder))
$InstallerFile = (Get-ChildItem -Path ("{0}*.exe" -f $TempFolder) -File).FullName

Write-Output "> Running Centrify Connector Installer..."
Invoke-Expression "$InstallerFile /silent /norestart"

$t = 1
while (!(Test-Path "C:\Program Files\Centrify\Centrify Connector\Centrify.Cloud.ProxyRegisterCli.exe")) 
{ 
	Write-Output ("Waiting for installation to finish... [{0:m\mss\s} elapsed]" -f [TimeSpan]::FromSeconds(10 * $t++))
	Start-Sleep -Seconds 10 
}

Write-Output "> Registering Centrify Connector against $TenantURL..."
& 'C:\Program Files\Centrify\Centrify Connector\Centrify.Cloud.ProxyRegisterCli.exe' url=$TenantURL regcode=$RegCode

Write-Output "> Starting Centrify Connector service..."
Start-Service adproxy

Write-Output "Done."

Stop-Transcript
