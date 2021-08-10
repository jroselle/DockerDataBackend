Write-Verbose "SSRS Config"

# Allow importing of modules
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Force

# Check and see if SSRS was installed.
Get-Service -Name "SQL Server Reporting Services" -ErrorVariable notPresent -ErrorAction SilentlyContinue | Out-Null
if ($notPresent) {
    Write-Host "SSRS does not appear installed - trying again"
    & ./installSSRS.ps1
}


# Retrieve the current configuration
$configset = Get-WmiObject `
    -namespace "root\Microsoft\SqlServer\ReportServer\RS_SSRS\v15\Admin" `
    -class MSReportServer_ConfigurationSetting `
    -ComputerName localhost

If ($configset.IsInitialized -eq $false) {
    # Get the ReportServer and ReportServerTempDB creation script
    [string]$dbscript = $configset.GenerateDatabaseCreationScript("ReportServer", 1033, $false).Script

    # Import the SQL Server PowerShell module
    Import-Module sqlps -DisableNameChecking | Out-Null

    # Establish a connection to the 
    $conn = New-Object Microsoft.SqlServer.Management.Common.ServerConnection -ArgumentList $env:ComputerName

    $conn.ApplicationName = "Setup Script"
    $conn.StatementTimeout = 0
    $conn.Connect()
    $smo = New-Object Microsoft.SqlServer.Management.Smo.Server -ArgumentList $conn

    # Create the ReportServer and ReportServerTempDB databases
    $db = $smo.Databases["master"]
    $db.ExecuteNonQuery($dbscript)

    # Set permissions for the databases
    $dbscript = $configset.GenerateDatabaseRightsScript($configset.WindowsServiceIdentityConfigured, "ReportServer", $false, $true).Script
	$db.ExecuteNonQuery($dbscript)

    Write-Host "Databases Created"

    # Set the database connection info
    $configset.SetDatabaseConnection("(local)", "ReportServer", 2, "", "")

    $configset.SetVirtualDirectory("ReportServerWebService", "ReportServer", 1033)
    $configset.ReserveURL("ReportServerWebService", "http://+:80", 1033)

    Write-Host "Reserving URL #1 Complete"

    # Did the name change?
    $configset.SetVirtualDirectory("ReportServerWebApp", "Reports", 1033)
    $configset.ReserveURL("ReportServerWebApp", "http://+:80", 1033)

    Write-Host "Reserving URL #2 Complete"

    $configset.InitializeReportServer($configset.InstallationID)
    Write-Host "Init Complete"


    # Seems to be necessary - was receiving cryptic errors from SSRS
    $configset.ReencryptSecureInformation()
    Write-Host "Re-encrypt complete"


    # Re-start services?
    $configset.SetServiceState($false, $false, $false)
    Restart-Service $configset.ServiceName
    $configset.SetServiceState($true, $true, $true)

    Write-Host "SSRS Restart Complete"
}