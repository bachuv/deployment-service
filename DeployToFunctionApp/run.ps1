using namespace System.Net

param($appInfo)

#$appInfoHashTable = ConvertFrom-StringData -StringData $appInfo

#"**********DEPLOY - Connecting to Azure Account***********"
#$azureAplicationId ="a927d29b-a40a-4242-976e-e44af4c61ccc"
#$azureTenantId= "72f988bf-86f1-41af-91ab-2d7cd011db47"
#$azurePassword = ConvertTo-SecureString "<password>" -AsPlainText -Force
#$psCred = New-Object System.Management.Automation.PSCredential($azureAplicationId , $azurePassword)
#$DefaultProfile = Connect-AzAccount -Credential $psCred -TenantId $azureTenantId  -ServicePrincipal

#"**********Deploying a zip file to Function***********"
#Publish-AzWebApp -ResourceGroupName $appInfoHashTable.ResourceGroup -Name $appInfoHashTable.FunctionName -DefaultProfile $DefaultProfile -ArchivePath <zip file path> -Force

# ************Download from GitHub and create a zip file*********

# Clone the project into the %TEMP% directory
Write-Host "Cloning https://github.com/cgillum/dfperf-scenarios..."
git clone https://github.com/cgillum/dfperf-scenarios $env:TEMP\dfperf-dedicated

# Build the project using the "publish" command so we can get the output for publishing
#Set-Location $env:TEMP\dfperf-dedicated
#dotnet publish -p:DeployTarget=Package

# Create the zip file for publishing
#Write-Host "Creating $env:TEMP\dfperf-dedicated\DFPerfScenarios\app.zip..."
#[System.IO.Compression.ZipFile]::CreateFromDirectory("$env:TEMP\dfperf-dedicated\DFPerfScenarios\bin\Debug\netcoreapp3.1\publish\", "$env:TEMP\app.zip")

# Get the path to the zip file (using dir to make sure it's actually there)
#$zipFilePath = Get-ChildItem $env:TEMP -Filter *.zip | Select-Object -ExpandProperty FullName

# Triggering the many instances function
#$payload = 100
#$json = $payload | ConvertTo-Json
#Invoke-RestMethod "https://dfperf-dedicated2.azurewebsites.net/tests/StartManyInstances?code=<code>" -Method POST -Body $json -ContentType "application/json"
