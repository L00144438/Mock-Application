#clear
$ErrorActionPreference = "Stop"
$services = "lfsvc"
$dbBackupLocation = "C:\DBBackup\1.bac"
$dbServer = "(local)"
$dbName = "MockDB2"
$dacpacPath = "C:\Dissertation\Mock Application\Mock-Application\src\DacPac\MockDB.dacpac"
$SqlPackageExePath = "C:\Program Files\Microsoft SQL Server\150\DAC\bin\sqlpackage.exe"
$srv = new-object microsoft.sqlserver.management.smo.server '.';

# Check for version change
# Initialise
# Downloads Artifact


# Stop Services
try {
    foreach ($service in $services) {
        #Get-Service $service | Where-Object {$_.Status -EQ "Running"} | Stop-Service  #| write-Host "Stopping Service: $sevice" | Stop-Service $service
        #stop-service $service
        If ((Get-Service $Service).Status -eq "Running") { 
            Stop-Service $Service
            Do {  
                Start-Sleep -Seconds 10
                }  
            Until ((Get-Service $Service).Status -eq "Stopped")
}
        
        
        }
    }
catch {
    Write-Error $_
    }


# Copy files

# Backup DB
try {
    if ( $null -ne $srv.Databases[$dbName] ) {
        Backup-SqlDatabase -ServerInstance $dbServer -Database $dbName -BackupFile $dbBackupLocation
        }
    }
catch {
    Write-Error $_
    }


# Deploy DACPAC
try {
    &"$SqlPackageExePath" `
        /Action:Publish `
        /SourceFile:"$dacpacPath" `
        /TargetServerName:$dbServer `
        /TargetDatabaseName:$dbName `
        /TargetUser:"sa" `
        /TargetPassword:"SubContractor!1" `
        #/p:BackupDatabaseBeforeChanges=true
        #/p:CreateNewDatabase=true #/Profile:"$DacPacUpdatedProfilePath"
    }
catch {
    Write-Error $_
    }


# Start Service
try {
    #foreach ($service in $services) {Start-Service $service}
    }
catch {
    Write-Error $_
    }


# Run Tests
# Finalise Job
