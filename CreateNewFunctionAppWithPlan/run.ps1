using namespace System.Net

param($Request, $TriggerMetadata)

$ErrorActionPreference = "Stop"

# Parameters
$appName = $Request.Body.appName
$resourceGroup = $Request.Body.resourceGroup
$storageAccount = $Request.Body.storageAccount
$runtime = $Request.Body.runtime
$subscriptionId = $Request.Body.subscriptionId
$appPlanName = $Request.Body.appPlanName

$functionsVersion = $Request.Body.functionsVersion
$osType = $Request.Body.OSType

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
Set-AzContext -SubscriptionId $subscriptionId

Write-Host "New-AzFunctionApp -Name $appName -PlanName $appPlanName -ResourceGroupName $resourceGroup -StorageAccount $storageAccount -Runtime $runtime -SubscriptionId $subscriptionId -FunctionsVersion $functionsVersion"

try {
    New-AzFunctionApp -Name $appName -PlanName $appPlanName -ResourceGroupName $resourceGroup -StorageAccount $storageAccount -Runtime $runtime -SubscriptionId $subscriptionId -FunctionsVersion $functionsVersion

    Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
        StatusCode = [HttpStatusCode]::Created
    })
}
catch {
    Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
        StatusCode = [HttpStatusCode]::BadRequest
    })
}