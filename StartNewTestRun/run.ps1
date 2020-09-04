param($Context)

$appInfo = @'
ResourceGroup = vabachudurablerg
FunctionName = VabachuDurablePowershellApp2
Location = centralUS
StorageAccount = vabachudurablestorage3
Runtime = PowerShell
SubscriptionID = <subscription id>
IdentityType = SystemAssigned
'@


#Invoke-ActivityFunction -FunctionName 'CreateNewResources' -Input $appInfo
#Invoke-ActivityFunction -FunctionName 'CreateNewFunctionApp' -Input $appInfo
$output = Invoke-ActivityFunction -FunctionName 'DeployToFunctionApp' -Input $appInfo
#Invoke-ActivityFunction -FunctionName 'DeleteFunctionApp' -Input $appInfo
#Invoke-ActivityFunction -FunctionName 'DeleteResources' -Input $appInfo
