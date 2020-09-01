param(
    [Parameter(Mandatory = $true)]$ResourceGroup,
    [Parameter(Mandatory = $true)]$WorkbooksFolder,
    [Parameter(Mandatory = $true)]$WorkbookSourceId
)

Write-Host "Folder is: $($WorkbooksFolder)"

$armTemplateFiles = Get-ChildItem -Path $WorkbooksFolder -Filter *.json

Write-Host "Files are: " $armTemplateFiles

foreach ($armTemplate in $armTemplateFiles) {

    $error.clear()
    $output = New-AzResourceGroupDeployment -Name "WorkbookDeployment" -ResourceGroupName $ResourceGroup -TemplateFile $armTemplate -TemplateParameterObject @{workbookSourceId = $WorkbookSourceId } -ErrorAction SilentlyContinue
    if ($output.ProvisioningState -eq "Failed") {
            
        if ($error -match "name already exists") {
            "Workbook with name {0} already exists." -f $output.parameters.item("workbookDisplayName").Value
        }
        else {
            $error
        }
    }
    else {
        "Workbook {0} successfully imported." -f $output.parameters.item("workbookDisplayName").Value
    }

}