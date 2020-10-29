using namespace System.Net

param($Request, $TriggerMetadata)

$ErrorActionPreference = "Stop"

$resourceGroupName = $Request.Body.resourceGroup
$appName = $Request.Body.appName
$subscriptionId = $Request.Body.subscriptionId
Set-AzContext -SubscriptionId $subscriptionId

try
{
    Get-AzFunctionApp -ResourceGroupName $resourceGroupName -Name $appName
    Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
        StatusCode = [HttpStatusCode]::OK
    })
}
catch
{
    Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
        StatusCode = [HttpStatusCode]::NotFound
    })
}