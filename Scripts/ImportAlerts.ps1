param(

    $workspaceName,
    $folderName
)

#Adding AzSentinel module
Install-Module AzSentinel -Scope CurrentUser -Force
Import-Module AzSentinel

$rules = Get-AzSentinelAlertRule -WorkspaceName $workspaceName | Select-Object -ExpandProperty DisplayName
Get-Item "$folderName\*.json" | ForEach-Object {
    
    $rule = $_.Name.Replace(".json", "")
    if ($rules -notcontains $rule) {
        "Importing rule: {0}" -f $rule
        "Current object in the pipe is: {0} " -f $_
        Import-AzSentinelAlertRule -WorkspaceName $workspaceName -SettingsFile $_
        "Rule {0} successfully imported!" -f $rule

    }
}
