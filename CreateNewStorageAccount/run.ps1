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

#Create new storage account
New-AzStorageAccount -ResourceGroupName $appInfoHashTable.ResourceGroup -AccountName $appInfoHashTable.StorageAccount -Location $appInfoHashTable.Location -SkuName Standard_GRS

Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
    StatusCode = [HttpStatusCode]::Created
})