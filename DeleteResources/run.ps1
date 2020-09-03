param($appInfo)

$appInfoHashTable = ConvertFrom-StringData -StringData $appInfo

#Delete storage account
Remove-AzStorageAccount -ResourceGroupName $appInfoHashTable.ResourceGroup -AccountName $appInfoHashTable.StorageAccount -Force

#Delete resource group
Remove-AzResourceGroup -Name $appInfoHashTable.ResourceGroup -Force