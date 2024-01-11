# Download and Install Google Chrome
$chromeInstaller = "script.exe"
Invoke-WebRequest "https://dl.google.com/chrome/install/latest/chrome_installer.exe" -OutFile $chromeInstaller
Start-Process -FilePath $chromeInstaller -Args "/silent /install" -Wait
Remove-Item -Path $chromeInstaller

# Set up bookmarks - Example
$bookmarksPath = "$env:USERPROFILE\AppData\Local\Google\Chrome\User Data\Default\Bookmarks"
$bookmarksContent = @{
    "checksum" = "1234567890"
    "roots" = @{
        "bookmark_bar" = @{
            "children" = @(
                @{
                    "name" = "Example Bookmark"
                    "type" = "url"
                    "url" = "https://www.example.com"
                }
            )
            "type" = "folder"
        }
    }
} | ConvertTo-Json

# Wait for Chrome to finish installing
Start-Sleep -Seconds 60

# Write bookmarks file
$bookmarksContent | Out-File -FilePath $bookmarksPath -Force -Encoding utf8
