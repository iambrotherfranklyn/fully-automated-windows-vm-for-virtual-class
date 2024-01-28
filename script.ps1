# PowerShell script to install Google Chrome
# Define the URL for the Google Chrome installer
$chromeDownloadUrl = "https://dl.google.com/tag/s/dl/chrome/install/googlechromestandaloneenterprise64.msi"

# Define the path where the installer will be downloaded
$downloadPath = "$env:TEMP\googlechromestandaloneenterprise64.msi"

# Download the installer
Invoke-WebRequest -Uri $chromeDownloadUrl -OutFile $downloadPath

# Install Google Chrome silently without user interaction
Start-Process 'msiexec.exe' -ArgumentList "/i $downloadPath /qn /norestart" -Wait -NoNewWindow

# Clean up - delete the installer
Remove-Item -Path $downloadPath -Force




