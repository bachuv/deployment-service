param($Request, $TriggerMetadata)

$ErrorActionPreference = "Stop"

"**********REMOVE - Connecting to Azure Account***********"
$azureAplicationId = "a927d29b-a40a-4242-976e-e44af4c61ccc"
$azureTenantId = "72f988bf-86f1-41af-91ab-2d7cd011db47"
$azurePassword = ConvertTo-SecureString  $env:DFTEST_AAD_CLIENT_SECRET -AsPlainText -Force
$psCred = New-Object System.Management.Automation.PSCredential($azureAplicationId , $azurePassword)
Connect-AzAccount -Credential $psCred -TenantId $azureTenantId  -ServicePrincipal

"**********Removing Azure Function App***********"
$appName = $Request.Body.appName
$resourceGroup = $Request.Body.resourceGroup
$subscriptionId = $Request.Body.subscriptionId

# Validate parameters
if (!$appName) {
    Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
        StatusCode = [System.Net.HttpStatusCode]::BadRequest
        Body = "The request JSON must contain an 'appName' field."
    })
    return
}

Remove-AzFunctionApp -Name $appName -ResourceGroupName $resourceGroup -Force

Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
    StatusCode = [System.Net.HttpStatusCode]::OK
})