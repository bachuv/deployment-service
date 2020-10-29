using namespace System.Net

param($Request, $TriggerMetadata)

$resourceGroupName = $Request.Body.resourceGroup
$subscriptionId = $Request.Body.subscriptionId

"**********CREATE - Connecting to Azure Account***********"
$azureAplicationId = "a927d29b-a40a-4242-976e-e44af4c61ccc"
$azureTenantId = "72f988bf-86f1-41af-91ab-2d7cd011db47"
$azurePassword = ConvertTo-SecureString $env:DFTEST_AAD_CLIENT_SECRET -AsPlainText -Force
$psCred = New-Object System.Management.Automation.PSCredential($azureAplicationId , $azurePassword)
Set-AzContext -SubscriptionId $subscriptionId

try {
   #Create new resource group
    New-AzResourceGroup -Name $resourceGroupName -Location "centralUS"

    Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
        StatusCode = [HttpStatusCode]::Created
    }) 
}
catch {
    Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
        StatusCode = [HttpStatusCode]::BadRequest
    })
}