param($appInfo)

$appInfoHashTable = ConvertFrom-StringData -StringData $appInfo

#Create new resource group
New-AzResourceGroup -Name $appInfoHashTable.ResourceGroup -Location $appInfoHashTable.Location

#Create new storage account
New-AzStorageAccount -ResourceGroupName $appInfoHashTable.ResourceGroup -AccountName $appInfoHashTable.StorageAccount -Location $appInfoHashTable.Location -SkuName Standard_GRS