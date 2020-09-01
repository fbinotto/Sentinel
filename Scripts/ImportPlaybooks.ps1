param(
    [Parameter(Mandatory = $true)]$ResourceGroup,
    [Parameter(Mandatory = $true)]$PlaybooksFolder
)

Write-Host "Folder is: $($PlaybooksFolder)"

$armTemplateFiles = Get-ChildItem -Path $PlaybooksFolder -Filter *.json

Write-Host "Files are: " $armTemplateFiles


foreach ($armTemplate in $armTemplateFiles) {
    $logicAppName = $armTemplate.Name.Replace(".json","")
    if (Get-AzLogicApp -ResourceGroupName $ResourceGroup -Name $logicAppName -ErrorAction SilentlyContinue) {
        "Logic App {0} already exists. Skipping." -f $logicAppName
    }
    else {
        try {
            New-AzResourceGroupDeployment -Name "PlaybookDeployment" -ResourceGroupName $ResourceGroup -TemplateFile $armTemplate.FullName
        }
        catch {
            $ErrorMessage = $_.Exception.Message
            Write-Error "Playbook deployment failed with message: $ErrorMessage" 
        }
    }
}
