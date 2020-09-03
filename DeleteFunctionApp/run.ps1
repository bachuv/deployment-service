param($appInfo)

$appInfoHashTable = ConvertFrom-StringData -StringData $appInfo

"**********REMOVE - Connecting to Azure Account***********"
$azureAplicationId ="a927d29b-a40a-4242-976e-e44af4c61ccc"
$azureTenantId= "72f988bf-86f1-41af-91ab-2d7cd011db47"
$azurePassword = ConvertTo-SecureString "<password>" -AsPlainText -Force
$psCred = New-Object System.Management.Automation.PSCredential($azureAplicationId , $azurePassword)
Connect-AzAccount -Credential $psCred -TenantId $azureTenantId  -ServicePrincipal

"**********Removing Azure Function App***********"
Remove-AzFunctionApp -Name $appInfoHashTable.FunctionName -ResourceGroupName $appInfoHashTable.ResourceGroup -SubscriptionId $appInfoHashTable.SubscriptionID -Force