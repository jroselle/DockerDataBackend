@echo off
echo Resetting sa password
sqlcmd -Q "alter login sa with password='%sa_password%'"

echo Configure SSRS
powershell -File .\configureSSRS.ps1

echo Resetting %ssrs_user% password
NET USER %ssrs_user% %ssrs_password%

echo Starting Cosmos Emulator
start "" "c:\Program Files\Azure Cosmos DB Emulator\CosmosDB.Emulator.exe" /noui /AllowNetworkAccess /NoFirewall /Key=C2y6yDjf5/R+ob0N8A7Cgv30VRDJIWEHLM+4QDU5DE2nQ9nDuVTqobD4b8mGGyPMbIZnqyMsEcaGQy67XIw/Jw==

echo Installing Azurite
cmd /c npm install -g azurite
echo Starting Azurite
cmd /c azurite --blobHost 0.0.0.0 --queueHost 0.0.0.0 --tableHost 0.0.0.0
