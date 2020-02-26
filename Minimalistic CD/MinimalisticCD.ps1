<#
.SYNOPSIS
    Minimalistic Continuous Delivery
.DESCRIPTION
    Continuous Delivery Pipeline Stages
    Connect to remote
    Check if version updated
    Download Files
    Stop services
    Backup DB
    Deploy DB (DACPAC)
    Start Sercives
    Run Automated Tests
.EXAMPLE
    Compare-Baseline 
.NOTES
    File Name    : MinimalisticCD.ps1
    Author       : Lee Tamplin
    Created Date : 17/02/2020
    To do        :    
#>

Import-Module SqlServer 

# Settings
$services          = "lfsvc","spooler" # Comma seperated list of services required to be stopped before update and started after
$dbBackupLocation  = "C:\DBBackup\1.bac" # DB backup location - overwritten on each run
$dbServer          = "(local)" # Database Server name
$dbName            = "MockDB2"# Database Name
$drop              = "C:\Release"
$dacpacSubFolder   = "\drop\DacPac\"
$dacpacName        = "MockDB.dacpac"
$dacpacPath        = (Join-Path -Path $drop -ChildPath $dacpacSubFolder) + $dacpacName # Location of downloaded DACPAC 
$sqlPackageExePath = "C:\Program Files\Microsoft SQL Server\150\DAC\bin\sqlpackage.exe" # Path to sqlpackage.exe
$userName          = "" # DB username (blank use trusted connection)
$password          = "" # DB password (blank use trusted connection)

# Powershell options
$ErrorActionPreference = "Stop"


<#
.SYNOPSIS
    Updates time out
.DESCRIPTION
    used to update time-out variables
.OUTPUTS
    updated timeout integer
.EXAMPLE
    $timeout = (Time-Out $timeout) 
#>
function Time-Out {
    param ($timeOutSec)
    
    Process {
        Start-Sleep -Seconds 1
        $timeOutSec ++ 
        return $timeOutSec
    }      
}


<#
.SYNOPSIS
    SSH Connection to remote delivery server
.DESCRIPTION
    used to check current version and download new versions
.OUTPUTS
    None
.EXAMPLE
    
#>
function Connect-DeliveryServer {
    Process {
        try {
            $session = new-pssession -Hostname 192.168.1.10 -UserName ContinuousDelivery # Connect to Continuous Delivery Server
            $source = invoke-command $session -scriptblock {Check-Release} # Get Path to new version
            Copy-Item -FromSession $session $source -Destination $drop -Recurse -Force # Download version files
            Remove-PSSession -Session $session # Close session
            }
            catch {
            Write-Error $_
            return $false
        }
        return $true
    }      
}

$session = new-pssession -Hostname 192.168.1.10 -UserName ContinuousDelivery
invoke-command $session -scriptblock {Check-Release}
Copy-Item -FromSession $session C:\drop\ -Destination C:\release -Recurse -Force


<#
.SYNOPSIS
    Stops Services
.DESCRIPTION
    Stops all services listed in the $services setting
.OUTPUTS
    Boolean Returns true if all services stopped
.EXAMPLE
    C:\PS> Stop-Services "lfsvc","gupdate"
#>
function Stop-Services {
    param ($services)
    
    Process {
        try {
            foreach ($service in $services) {
                If ((Get-Service $Service).Status -eq "Running") { 
                    Write-Host "Stopping Service: $service"
                    Stop-Service $Service
                    Do {                
                        $timeout = (Time-Out $timeout)                
                    }  
                    Until (((Get-Service $Service).Status -eq "Stopped") -or ($timeout -eq 5))
                }        
            }
        }
        catch {
            Write-Error $_
            return $false
        }
        return $true
    }
}



<#
.SYNOPSIS
    Starts Services
.DESCRIPTION
    Starts all services listed in the $services setting
.OUTPUTS
    Boolean Returns true if all services started
.EXAMPLE
    C:\PS> Start-Services "lfsvc,gupdate"
#>
function Start-Services {
    param ($services)
    
    Process {
        try {
            foreach ($service in $services) {                
                If ((Get-Service $Service).Status -ne "Running") { 
                    Write-Host "Starting Service: $service"
                    Start-Service $Service
                    Do {                
                        $timeout = (Time-Out $timeout)                
                    }  
                    Until (((Get-Service $Service).Status -eq "Running") -or ($timeout -eq 5))
                }        
            }
        }
        catch {
            Write-Error $_
            return $false
        }
        return $true
    }
}


<#
.SYNOPSIS
    Backup DB
.DESCRIPTION
    Backs up a DB if it exists
.OUTPUTS
    Boolean Returns true if DBBacked up
.EXAMPLE
    C:\PS> Backup-SQLDB -dbServer ServerName -dbName DatabaseName -dbBackupLocation Directory
#>
function Backup-SQLDB {
    param (
        [Parameter (position=0)][string] $dbServer,
        [Parameter (position=1)][string] $dbName,
        [Parameter (position=2)][string] $dbBackupLocation
    )
    
    Process {    
        try {
            $srv = new-object microsoft.sqlserver.management.smo.server        
            if ($null -ne $srv.Databases[$dbName]) {
                Write-Host "Backup DB: $dbName"
                Backup-SqlDatabase `
                    -ServerInstance $dbServer `
                    -Database $dbName `
                    -BackupFile $dbBackupLocation
            }
        }
        catch {
            Write-Error $_
            return $false
        }
        return $true
    }
}


<#
.SYNOPSIS
    Deploy DACPAC
.DESCRIPTION
    Publishes a DACPAC - Creates DB if doesn't exist
.OUTPUTS
    Boolean Returns true if DACPAC published
.EXAMPLE
    C:\PS> Start-Services "lfsvc,gupdate"
#>
function Publish-DACPAC {
    param (
        [Parameter ()][string] $sqlPackageExePath,
        [Parameter ()][string] $dacpacPath,
        [Parameter ()][string] $dbServer,
        [Parameter ()][string] $dbName,
        [Parameter ()][string] $userName,
        [Parameter ()][string] $password
    )
    
    Process {    
        try {            
            if ($userName -ne "") {
                &"$sqlPackageExePath" `
                    /Action:Publish `
                    /SourceFile:"$dacpacPath" `
                    /TargetServerName:$dbServer `
                    /TargetDatabaseName:$dbName `
                    /TargetUser:$userName `
                    /TargetPassword:$password | Write-Host
            } 
            else {                
                &"$sqlPackageExePath" `
                    /Action:Publish `
                    /SourceFile:"$dacpacPath" `
                    /TargetServerName:$dbServer `
                    /TargetDatabaseName:$dbName | Write-Host
            }            
        }
        catch {
            Write-Error $_
            return $false
        }
        return $true
    }
}


function Run-PipeLine {
    [CmdletBinding()]
    param ()

    begin {
    }

    process {       
       
       if ((Connect-DeliveryServer)                                                               -eq $false) {break}
       if ((Stop-Services  $services)                                                             -eq $false) {break}
       if ((Backup-SQLDB -dbServer $dbServer -dbName $dbName -dbBackupLocation $dbBackupLocation) -eq $false) {break}
       if ((Publish-DACPAC $sqlPackageExePath $dacpacPath $dbServer $dbName $username $password)  -eq $false) {break}
       if ((Start-Services $services)                                                             -eq $false) {break}
    }
    
    end {        
    }   
}

Run-PipeLine