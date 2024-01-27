# PowerShell script to install Google Chrome

# Define the URL for the Google Chrome installer
$chromeDownloadUrl = "https://dl.google.com/chrome/install/ChromeStandaloneSetup.exe"

# Define the path where the installer will be downloaded
$downloadPath = "$env:TEMP\ChromeStandaloneSetup.exe"

# Download the installer
try {
    Invoke-WebRequest -Uri $chromeDownloadUrl -OutFile $downloadPath
    Write-Host "Downloaded the installer."
} catch {
    Write-Host "Failed to download the installer: $_"
    exit
}

# Install Google Chrome silently without user interaction
try {
    Start-Process -FilePath $downloadPath -Args "/silent /install" -Wait -PassThru
    Write-Host "Installation started."
} catch {
    Write-Host "Failed to start installation: $_"
    exit
}

# Clean up - delete the installer
try {
    Remove-Item -Path $downloadPath
    Write-Host "Cleaned up the installer."
} catch {
    Write-Host "Failed to clean up the installer: $_"
}


# Define the bookmarks with their names
$bookmarks = @{
    "Folder1" = @{
        "dotnet apps" = "https://fwdays.com/en/event/dotnet-fwdays-2020/review/securing-dotnet-apps-and-microservices-in-azure"
    }
    "Folder2" = @{
        "stackoverflow" = "https://stackoverflow.com/questions/54428054/how-to-secure-azure-serverless-microservice-architecture"
    }
    "Folder3" = @{
        "github" = "https://github.com/iambrotherfranklyn/housekeeping/blob/main/tool-installations.ps1"
    }
}

# Create a new directory for the HTML file
$directoryPath = "C:\Users\$env:USERNAME\Documents\Bookmarks"
New-Item -Path $directoryPath -ItemType Directory -Force

# Create a new HTML file
$htmlFilePath = "$directoryPath\bookmarks.html"
New-Item -Path $htmlFilePath -ItemType File -Force

# Write the HTML header to the file
Add-Content -Path $htmlFilePath -Value "<!DOCTYPE NETSCAPE-Bookmark-file-1>"
Add-Content -Path $htmlFilePath -Value "<META HTTP-EQUIV=`"Content-Type`" CONTENT=`"text/html; charset=UTF-8`">"
Add-Content -Path $htmlFilePath -Value "<Title>Bookmarks</Title>"
Add-Content -Path $htmlFilePath -Value "<H1>Bookmarks</H1>"
Add-Content -Path $htmlFilePath -Value "<DL><p>"

# Write each bookmark to the file
foreach ($folder in $bookmarks.Keys) {
    Add-Content -Path $htmlFilePath -Value "`t<DT><H3>$folder</H3>"
    Add-Content -Path $htmlFilePath -Value "`t<DL><p>"
    foreach ($name in $bookmarks[$folder].Keys) {
        $bookmark = $bookmarks[$folder][$name]
        Add-Content -Path $htmlFilePath -Value "`t`t<DT><A HREF=`"$bookmark`">$name</A>"
    }
    Add-Content -Path $htmlFilePath -Value "`t</DL><p>"
}

# Write the HTML footer to the file
Add-Content -Path $htmlFilePath -Value "</DL><p>"