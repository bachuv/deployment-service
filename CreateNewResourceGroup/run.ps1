param($Request, $TriggerMetadata)

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

#Create new resource group
New-AzResourceGroup -Name $appInfoHashTable.ResourceGroup -Location $appInfoHashTable.Location

Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
    StatusCode = [HttpStatusCode]::Created
})