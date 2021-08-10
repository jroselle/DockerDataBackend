Start-Process -Wait -FilePath .\SQLServerReportingServices.exe -ArgumentList "/quiet", "/norestart", "/IAcceptLicenseTerms", "/Edition=EVAL" -PassThru -Verbose 

Write-Host "Adding $env:ssrs_user"
net user $env:ssrs_user $env:ssrs_password /add
net localgroup Administrators $env:ssrs_user /add