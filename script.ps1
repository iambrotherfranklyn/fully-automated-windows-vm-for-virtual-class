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