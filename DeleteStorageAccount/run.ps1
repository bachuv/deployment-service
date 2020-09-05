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

#Delete storage account
Remove-AzStorageAccount -ResourceGroupName $appInfoHashTable.ResourceGroup -AccountName $appInfoHashTable.StorageAccount -Force

Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
    StatusCode = [HttpStatusCode]::OK
})