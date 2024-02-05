# Sign in to your Azure account
Connect-AzAccount -TenantId "6ccb7334-6f39-4d56-b82a-319cd9a5a549"

# Azure Subscription I want to use
$subscriptionId = "e243c19f-f5d7-4038-bdc7-a77ce40f79c3"

# Resource Group my VMs are in
$resourceGroup = "cyber-gees-rg"

# Select the right Azure subscription
Set-AzContext -SubscriptionId $subscriptionId

# Check if the resource group exists
if (-Not (Get-AzResourceGroup -Name $resourceGroup -ErrorAction SilentlyContinue)) {
    Write-Host "Resource group '$resourceGroup' could not be found." -ForegroundColor Red
    exit
}

# Get all Azure VMs which are in running state and are running Windows
$myAzureVMs = Get-AzVM -ResourceGroupName $resourceGroup -Status | Where-Object { $_.PowerState -eq "VM running" -and $_.StorageProfile.OsDisk.OsType -eq "Windows" }

# Define the script to install Google Chrome
$chromeInstallScript = @'
try {
    Invoke-WebRequest -Uri "https://dl.google.com/tag/s/dl/chrome/install/googlechromestandaloneenterprise64.msi" -OutFile "$env:TEMP\googlechromestandaloneenterprise64.msi" -ErrorAction Stop
    Start-Process 'msiexec.exe' -ArgumentList "/i `$env:TEMP\googlechromestandaloneenterprise64.msi /qn /norestart" -Wait -NoNewWindow -ErrorAction Stop
    Remove-Item -Path "$env:TEMP\googlechromestandaloneenterprise64.msi" -Force
    "Google Chrome installed successfully."
} catch {
    "Error occurred: $_"
}
'@

# Run the script against all VMs
foreach ($vm in $myAzureVMs) {
    $out = Invoke-AzVMRunCommand -ResourceGroupName $vm.ResourceGroupName -Name $vm.Name -CommandId 'RunPowerShellScript' -ScriptString $chromeInstallScript
    # Check if $out is not null and has a value
    if ($out -and $out.Value) {
        $output = $vm.Name + ": " + $out.Value[0].Message
    } else {
        $output = $vm.Name + ": Script execution failed or returned no output."
    }
    Write-Output $output
}
