param (
    [string]$ResourceGroupName,
    [string]$SqlServerName,
    [string]$DatabaseName,
    [string]$ElasticPoolName,
    [int]$NewDTU
)

# Login to Azure account
Connect-AzAccount

# Check if Elastic Pool is provided or not
if (-not [string]::IsNullOrEmpty($ElasticPoolName)) {
    # Change DTU for the elastic pool
    $elasticPool = Get-AzSqlElasticPool -ResourceGroupName $ResourceGroupName -ServerName $SqlServerName -ElasticPoolName $ElasticPoolName
    $elasticPool.Dtu = $NewDTU
    $elasticPool | Set-AzSqlElasticPool
    Write-Output "DTU for elastic pool '$ElasticPoolName' changed to $NewDTU"
} else {
    # Change DTU for the SQL database
    $database = Get-AzSqlDatabase -ResourceGroupName $ResourceGroupName -ServerName $SqlServerName -DatabaseName $DatabaseName
    $database.MaxSizeBytes = $NewDTU * 1024 * 1024 * 1024 # Adjust as needed
    $database | Set-AzSqlDatabase
    Write-Output "DTU for database '$DatabaseName' changed to $NewDTU"
}
