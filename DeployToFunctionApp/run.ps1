using namespace System.Net

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

# ************Download from GitHub and create a zip file*********
$targetDir = "$env:TEMP\dfperf-dedicated"

# Delete the target directory if it already exists
if (Test-Path -Path $targetDir) {
    Write-Host "Deleting existing directory $targetDir..."
    Remove-Item $targetDir -Recurse -Force
}

# Clone the project into the %TEMP% directory
# Invoke git and capture both its stdout and stderr streams.
Write-Host "Cloning https://github.com/cgillum/dfperf-scenarios into $targetDir..."
$result = git clone https://github.com/cgillum/dfperf-scenarios $targetDir 2>&1
if ($LASTEXITCODE) {
    Throw "git failed (exit code: $LASTEXITCODE):`n$($result -join "`n")"
}
$result | ForEach-Object ToString

# Build the project using the "publish" command so we can get the output for publishing
Set-Location $env:TEMP\dfperf-dedicated
Write-Host "Building project..."
dotnet publish -p:DeployTarget=Package

# Create the zip file for publishing
$targetZipFilePath = "$env:TEMP\app.zip"
if (Test-Path -Path $targetZipFilePath) {
    Write-Host "Deleting existing $targetZipFilePath..."
    Remove-Item $targetZipFilePath -ErrorAction Ignore -Force
}
$zipSrc = "$targetDir\bin\Debug\netcoreapp3.1\publish\"
Write-Host "Zipping $zipSrc into $targetZipFilePath..."
[System.IO.Compression.ZipFile]::CreateFromDirectory($zipSrc, $targetZipFilePath)
Write-Host "$targetZipFilePath created successfully!"

#"**********DEPLOY - Connecting to Azure Account***********"
#$azureAplicationId ="a927d29b-a40a-4242-976e-e44af4c61ccc"
#$azureTenantId= "72f988bf-86f1-41af-91ab-2d7cd011db47"
#$azurePassword = ConvertTo-SecureString "<password>" -AsPlainText -Force
#$psCred = New-Object System.Management.Automation.PSCredential($azureAplicationId , $azurePassword)
#$DefaultProfile = Connect-AzAccount -Credential $psCred -TenantId $azureTenantId  -ServicePrincipal

#"**********Deploying a zip file to Function***********"
#Publish-AzWebApp -ResourceGroupName $appInfoHashTable.ResourceGroup -Name $appInfoHashTable.FunctionName -DefaultProfile $DefaultProfile -ArchivePath targetZipFilePath -Force

# Triggering the many instances function
#$payload = 100
#$json = $payload | ConvertTo-Json
#Invoke-RestMethod "https://dfperf-dedicated2.azurewebsites.net/tests/StartManyInstances?code=<code>" -Method POST -Body $json -ContentType "application/json"

Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
    StatusCode = [HttpStatusCode]::OK
})