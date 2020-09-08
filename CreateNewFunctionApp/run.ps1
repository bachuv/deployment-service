using namespace System.Net

param($Request, $TriggerMetadata)

$ErrorActionPreference = "Stop"

$appInfo = @'
ResourceGroup = vabachudurablerg5
FunctionName = VabachuDurablePowershellApp5
Location = centralUS
StorageAccount = vabachudurablestorage5
Runtime = PowerShell
SubscriptionID = <sub id>
IdentityType = SystemAssigned
'@

$appInfoHashTable = ConvertFrom-StringData -StringData $appInfo

# Parameters
$appName = $Request.Body.appName
$resourceGroup = $Request.Body.resourceGroup ?? "perf-testing"
$location = $Request.Body.location ?? "westus2"
$storageAccount = $Request.Body.storageAccount ?? "dfperfdedicatedstorage2"
$runtime = $Request.Body.runtime ?? "dotnet"

if (!$appName) {
    Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
        StatusCode = [HttpStatusCode]::BadRequest
        Body = "The request JSON must contain an 'appName' field."
    })
    return
}

"**********CREATE - Connecting to Azure Account***********"
$azureAplicationId = "a927d29b-a40a-4242-976e-e44af4c61ccc"
$azureTenantId = "72f988bf-86f1-41af-91ab-2d7cd011db47"
$azurePassword = ConvertTo-SecureString $env:DFTEST_AAD_CLIENT_SECRET -AsPlainText -Force
$psCred = New-Object System.Management.Automation.PSCredential($azureAplicationId , $azurePassword)
Connect-AzAccount -Credential $psCred -TenantId $azureTenantId -ServicePrincipal

Write-Host "New-AzFunctionApp -Name $appName -ResourceGroupName $resourceGroup -Location $location -StorageAccount $storageAccount -Runtime $runtime"
New-AzFunctionApp -Name $appName -ResourceGroupName $resourceGroup -Location $location -StorageAccount $storageAccount -Runtime $runtime

Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
    StatusCode = [HttpStatusCode]::Created
})