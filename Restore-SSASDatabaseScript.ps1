Function Restore-SSASDatabaseScript
{

    [CmdletBinding()]
	Param (
            [parameter(Position = 0, Mandatory = $true, ValueFromPipeline = $true)]
            [object]$sqlServer,
            [object]$path
        )
    
    Import-Module sqlserver;
    [System.Reflection.Assembly]::LoadWithPartialName("Microsoft.AnalysisServices") | Out-Null

    #Connect to the server. 
    $SSASServer = New-Object Microsoft.AnalysisServices.Server 
    $SSASServer.Connect($sqlServer)     

    Try{Invoke-ASCmd -InputFile $path -Server $SSASServer}
    Catch{Write-Host $_.Exception.Message}

}#End Restore-SSASDatabaseScript

Restore-SSASDatabaseScript -sqlServer Server1 -path "C:\Users\user\SSAS_backups\databaseBackup.xmla"