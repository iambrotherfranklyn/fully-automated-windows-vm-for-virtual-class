# Sign in to your Azure account
Connect-AzAccount

#Azure Subscription I want to use
$subscriptionId = "e243c19f-f5d7-4038-bdc7-a77ce40f79c3"

#Resource Group my VMs are in
$resourceGroup = "cyber-gees-rg"

#Select the right Azure subscription
Set-AzContext -Subscription $subscriptionId

#Get all Azure VMs which are in running state and are running Windows
$myAzureVMs = Get-AzVM -ResourceGroupName $resourceGroup -status | Where-Object {$_.PowerState -eq "VM running" -and $_.StorageProfile.OSDisk.OSType -eq "Windows"}

#Define the script to install Google Chrome
$chromeInstallScript = {
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
}

#Run the script against all VMs in parallel
$myAzureVMs | ForEach-Object -Parallel {
  $out = Invoke-AzVMRunCommand `
  -ResourceGroupName $_.ResourceGroupName `
  -Name $_.Name `
  -CommandId 'RunPowerShellScript' `
  -ScriptBlock $chromeInstallScript
  #Formatting the Output with the VM name
  $output = $_.Name + " " + $out.Value[0].Message
  $output
}
