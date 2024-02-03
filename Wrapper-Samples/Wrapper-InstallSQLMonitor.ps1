﻿#$DomainCredential = Get-Credential -UserName 'Lab\SQLServices' -Message 'AD Account'
#$saAdmin = Get-Credential -UserName 'sa' -Message 'sa'
#$localAdmin = Get-Credential -UserName 'Administrator' -Message 'Local Admin'

cls
Import-Module dbatools;
$params = @{
    SqlInstanceToBaseline = 'Workstation'
    DbaDatabase = 'DBA'
    #HostName = 'Workstation'
    #RetentionDays = 7
    DbaToolsFolderPath = 'D:\Github\dbatools' # Download using Save-Module command
    #FirstResponderKitZipFile = 'D:\Softwares\SQL-Server-First-Responder-Kit-20231010.zip' # Download from Releases section
    #DarlingDataZipFile = 'D:\Softwares\DarlingData-main.zip' # Download from Code dropdown    
    #OlaHallengrenSolutionZipFile = 'D:\Github\sql-server-maintenance-solution-master.zip' # Download from Code dropdown
    #RemoteSQLMonitorPath = 'C:\SQLMonitor'
    InventoryServer = 'SQLMonitor'
    InventoryDatabase = 'DBA'
    DbaGroupMailId = 'some_dba_mail_id@gmail.com'
    #SqlCredential = $personal
    #WindowsCredential = $DomainCredential
    <#
    SkipSteps = @( "1__sp_WhoIsActive", "2__AllDatabaseObjects", "3__XEventSession",
                "4__FirstResponderKitObjects", "5__DarlingDataObjects", "6__OlaHallengrenSolutionObjects",
                "7__sp_WhatIsRunning", "8__usp_GetAllServerInfo", "9__CopyDbaToolsModule2Host",
                "10__CopyPerfmonFolder2Host", "11__SetupPerfmonDataCollector", "12__CreateCredentialProxy",
                "13__CreateJobCollectDiskSpace", "14__CreateJobCollectOSProcesses", "15__CreateJobCollectPerfmonData",
                "16__CreateJobCollectWaitStats", "17__CreateJobCollectXEvents", "18__CreateJobCollectFileIOStats",
                "19__CreateJobPartitionsMaintenance", "20__CreateJobPurgeTables", "21__CreateJobRemoveXEventFiles",
                "22__CreateJobRunLogSaver", "23__CreateJobRunTempDbSaver", "24__CreateJobRunWhoIsActive",
                "25__CreateJobRunBlitzIndex", "26__CreateJobRunBlitz", "27__CreateJobRunBlitzIndexWeekly",
                "28__CreateJobCollectMemoryClerks", "29__CreateJobCollectPrivilegedInfo", "30__CreateJobCollectAgHealthState",
                "31__CreateJobCheckSQLAgentJobs", "32__CreateJobUpdateSqlServerVersions", "33__CreateJobCheckInstanceAvailability",
                "34__CreateJobGetAllServerInfo", "35__CreateJobGetAllServerCollectedData", "36__WhoIsActivePartition",
                "37__BlitzIndexPartition", "38__BlitzPartition", "39__EnablePageCompression",
                "40__GrafanaLogin", "41__LinkedServerOnInventory", "42__LinkedServerForDataDestinationInstance",
                "43__AlterViewsForDataDestinationInstance")
    #>
    #OnlySteps = @( "2__AllDatabaseObjects", "29__CreateJobCollectAgHealthState" )
    #StartAtStep = '1__sp_WhoIsActive'
    #StopAtStep = '39__AlterViewsForDataDestinationInstance'
    #DropCreatePowerShellJobs = $true
    #DryRun = $false
    #SkipRDPSessionSteps = $true
    #SkipPowerShellJobs = $true
    #SkipTsqlJobs = $true
    #SkipMailProfileCheck = $true
    #skipCollationCheck = $true
    #SkipWindowsAdminAccessTest = $true
    #SkipDriveCheck = $true
    #SkipPingCheck = $true
    #SkipMultiServerviewsUpgrade = $false
    #ForceSetupOfTaskSchedulerJobs = $true
    #SqlInstanceAsDataDestination = 'Workstation'
    #SqlInstanceForPowershellJobs = 'Workstation'
    #SqlInstanceForTsqlJobs = 'Workstation'
    #ConfirmValidationOfMultiInstance = $true
    #ConfirmSetupOfTaskSchedulerJobs = $true
    #HasCustomizedTsqlJobs = $true
    #HasCustomizedPowerShellJobs = $true
    #OverrideCustomizedTsqlJobs = $false
    #OverrideCustomizedPowerShellJobs = $false
    #UpdateSQLAgentJobsThreshold = $false
    #XEventDirectory = 'D:\MSSQL15.MSSQLSERVER\XEvents\'
    #JobsExecutionWaitTimeoutMinutes = 15
}

#$preSQL = "EXEC dbo.usp_check_sql_agent_jobs @default_mail_recipient = 'sqlagentservice@gmail.com', @drop_recreate = 1"
#$postSQL = Get-Content "D:\GitHub-Personal\SQLMonitor\DDLs\Update-SQLAgentJobsThreshold.sql"
#D:\GitHub\SQLMonitor\SQLMonitor\Install-SQLMonitor.ps1 @Params #-Debug -PreQuery $preSQL -PostQuery $postSQL
D:\GitHub\SQLMonitor\SQLMonitor\Install-SQLMonitor.ps1 @Params

#Get-Help F:\GitHub\SQLMonitor\SQLMonitor\Install-SQLMonitor.ps1 -ShowWindow

<#
$dropWhoIsActive = @"
if object_id('dbo.WhoIsActive_Staging') is not null
	drop table dbo.WhoIsActive_Staging;

if object_id('dbo.WhoIsActive') is not null
	drop table dbo.WhoIsActive;
"@;
F:\GitHub\SQLMonitor\SQLMonitor\Install-SQLMonitor.ps1 @Params -PreQuery $dropWhoIsActive
#>

<#
# **************** Download other github repos/modules/files ***********************

# **__ SQLMonitor __**
Invoke-WebRequest https://github.com/imajaydwivedi/SQLMonitor/archive/refs/heads/dev.zip `
            -OutFile "$($env:USERPROFILE)\Downloads\sqlmonitor.zip"
Expand-Archive "$($env:USERPROFILE)\Downloads\sqlmonitor.zip" "$($env:USERPROFILE)\Downloads"
Get-ChildItem "$($env:USERPROFILE)\Downloads\SQLMonitor-dev\SQLMonitor" | Copy-Item -Destination C:\SQLMonitor -Force -Verbose


# **__ dbatools & dbatools.library __**
Save-Module dbatools -Path "$($env:USERPROFILE)\Downloads\"

# **__ PoshRSJob on Inventory __**
Install-Module PoshRSJob -Scope AllUsers -Verbose
Save-Module PoshRSJob -Path "$($env:USERPROFILE)\Downloads\"

# **__ Darling Data __**
Invoke-WebRequest https://github.com/erikdarlingdata/DarlingData/archive/refs/heads/main.zip `
            -OutFile "$($env:USERPROFILE)\Downloads\DarlingData-main.zip"

# **__ Ola Hallengren Maintenance Solution __**
Invoke-WebRequest https://github.com/olahallengren/sql-server-maintenance-solution/archive/refs/heads/master.zip `
            -OutFile "$($env:USERPROFILE)\Downloads\sql-server-maintenance-solution-master.zip"

# **__ First Responder Kit from latest release __**
if ($true) {
    $repo = "BrentOzarULTD/SQL-Server-First-Responder-Kit"
    $tags = "https://api.github.com/repos/$repo/tags"

    $tagName = (Invoke-WebRequest $tags | ConvertFrom-Json)[0].name
    $releaseZip = "https://github.com/$repo/archive/refs/tags/$tagName.zip"
    $outFile = "$($env:USERPROFILE)\Downloads\SQL-Server-First-Responder-Kit-$tagName.zip"

    Invoke-WebRequest $releaseZip `
            -OutFile $outFile

    "File downloaded: '$outFile'" | Write-Host -ForegroundColor Green
}

# **__ PoshRSJob - Download from Github __**
if ($true) {
    $repo = "proxb/PoshRSJob"
    $releases = "https://api.github.com/repos/$repo/releases"

    $tagName = (Invoke-WebRequest $releases | ConvertFrom-Json)[0].tag_name
    $releaseZip = "https://github.com/$repo/releases/download/$tagName/PoshRSJob.zip"

    Invoke-WebRequest $releaseZip `
            -OutFile "$($env:USERPROFILE)\Downloads\PoshRSJob.zip"
}

#>

<#
Get-DbaDbMailProfile -SqlInstance '192.168.56.31' -SqlCredential $personalCredential
Copy-DbaDbMail -Source '192.168.56.15' -Destination '192.168.56.31' -SourceSqlCredential $personalCredential -DestinationSqlCredential $personalCredential # Lab
New-DbaCredential -SqlInstance 'xy' -Identity $LabCredential.UserName -SecurePassword $LabCredential.Password -Force # -SqlCredential $SqlCredential -EnableException
New-DbaAgentProxy -SqlInstance 'xy' -Name $LabCredential.UserName -ProxyCredential $LabCredential.UserName -SubSystem PowerShell,CmdExec

Enable-PSRemoting -Force -SkipNetworkProfileCheck # remote machine
Set-Item WSMAN:\Localhost\Client\TrustedHosts -Value SQLMonitor.Lab.com -Concatenate -Force # remote machine
Get-ItemProperty HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System -Name LocalAccountTokenFilterPolicy
Set-ItemProperty HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System -Name LocalAccountTokenFilterPolicy -Value 1

# Incase 
#Set-Item WSMAN:\Localhost\Client\TrustedHosts -Value * -Force # run on local machine
#Set-NetConnectionProfile -NetworkCategory Private # Execute this only if above command fails

Enter-PSSession -ComputerName '192.168.56.31' -Credential $localAdmin -Authentication Negotiate
Test-WSMan '192.168.56.31' -Credential $localAdmin -Authentication Negotiate

Get-ChildItem C:\SQLMonitor -Recurse -File | Unblock-File -Verbose
#>

<#
# Add SQLAgent Service Account to below local windows groups.
    # Computer Management > System Tools > Local Users and Groups > Groups
1) Administrators
2) Performance Log Users
3) Performance Monitor Users
#>