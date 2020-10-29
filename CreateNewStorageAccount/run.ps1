using namespace System.Net

param($Request, $TriggerMetadata)

$ErrorActionPreference = "Stop"

$resourceGroupName = $Request.Body.resourceGroup
$storageAccountName = $Request.Body.storageAccount
$Location = "centralUS"
$subscriptionId = $Request.Body.subscriptionId
Set-AzContext -SubscriptionId $subscriptionId

try {
    #Create new storage account
    New-AzStorageAccount -ResourceGroupName $resourceGroupName -AccountName $storageAccountName -Location $Location -SkuName Standard_GRS

    Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
        StatusCode = [HttpStatusCode]::Created
    })
}
catch {
    Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
        StatusCode = [HttpStatusCode]::BadRequest
    })
}