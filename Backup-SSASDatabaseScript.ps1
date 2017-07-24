Function Backup-SSASDatabaseScript
{

    [CmdletBinding()]
	Param (
            [parameter(Position = 0, Mandatory = $true, ValueFromPipeline = $true)]
            [object]$sqlServer,
            [object]$OutputFolder
        )

    [string]$ExecutionDate = (Get-Date).ToString("yyyyMMdd-HHmmss")
    
    [System.Reflection.Assembly]::LoadWithPartialName("Microsoft.AnalysisServices") | Out-Null
    [System.Reflection.Assembly]::LoadWithPartialName("System.Xml") | Out-Null

    #Connect to the server. 
    $SSASServer = New-Object Microsoft.AnalysisServices.Server 
    $SSASServer.Connect($sqlServer) 
    foreach ($db in $SSASServer.Databases) 
    {
        #[string]$OutputPath = "$OutputFolder\$db\"
        #Write-Host "Scripting:" $db.Name " "
        
        $FileWriter = New-Object System.Xml.XmlTextWriter("$($OutputFolder)SSAS_$($db.Name)_$($ExecutionDate).xmla", [System.Text.Encoding]::UTF8) 
        $FileWriter.Formatting = [System.Xml.Formatting]::Indented 
        [Microsoft.AnalysisServices.Scripter]::WriteCreate($FileWriter,$SSASServer,$db,$true,$true) 
        $FileWriter.Close()
        
        #Keep most recent .xmla file. Delete older one(s).
        $NumberToSave = 1
        $files = Get-ChildItem "$OutputFolder\*$db*.xmla" | Sort-Object LastWriteTime -Descending
        #$files
        
        if ($NumberToSave -lt $files.Count)
            {
                $files[$NumberToSave..($files.Count-1)] | Remove-Item
            } #End if.

    } #End foreach.

    #Disconnect from SSAS.
    $SSASServer.Disconnect()

}#End Backup-SSASDatabaseScript function.

#Backup-SSASDatabaseScript -sqlServer "Server1" -OutputFolder "C:\Users\user\SSAS_backups"