using namespace System.Net

param($Request, $TriggerMetadata)

$ErrorActionPreference = "Stop"

# Parameters
$appPlanName = $Request.Body.appPlanName
$resourceGroup = $Request.Body.resourceGroup
$location = $Request.Body.location ?? "centralus"
$subscriptionId = $Request.Body.subscriptionId

$sku = $Request.Body.sku
$workerType = $Request.Body.OSType
$minimumWorkerCount = $Request.Body.minInstanceCount
$maximumWorkerCount = $Request.Body.maxInstanceCount

if (!$appPlanName) {
    Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
        StatusCode = [HttpStatusCode]::BadRequest
        Body = "The request JSON must contain an 'appPlanName' field."
    })
    return
}

"**********CREATE - Connecting to Azure Account***********"
$azureAplicationId = "a927d29b-a40a-4242-976e-e44af4c61ccc"
$azureTenantId = "72f988bf-86f1-41af-91ab-2d7cd011db47"
$azurePassword = ConvertTo-SecureString $env:DFTEST_AAD_CLIENT_SECRET -AsPlainText -Force
$psCred = New-Object System.Management.Automation.PSCredential($azureAplicationId , $azurePassword)
Set-AzContext -SubscriptionId $subscriptionId

Write-Host "New-AzFunctionAppPlan -Location $location -Name $appPlanName -ResourceGroupName $resourceGroup -Sku $sku -WorkerType $workerType -MinimumWorkerCount $minimumWorkerCount -MaximumWorkerCount $maximumWorkerCount"

try {
    New-AzFunctionAppPlan -Location $location -Name $appPlanName -ResourceGroupName $resourceGroup -Sku $sku -WorkerType $workerType -MinimumWorkerCount $minimumWorkerCount -MaximumWorkerCount $maximumWorkerCount

    Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
        StatusCode = [HttpStatusCode]::Created
    })
}
catch {
    Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
        StatusCode = [HttpStatusCode]::BadRequest
    })
}
