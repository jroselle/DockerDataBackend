@echo off
@echo This file is provided for your convenience due to the very large number of port mappings needed.
@echo you should replace the password and username
@echo Running this script indicates you've accepted all applicable EULAs 
docker run --name DataBackend --dns 8.8.8.8 ^
-e sa_password=ReplaceMe100! ^
-e ssrs_user=bob ^
-e ssrs_password=ReplaceMe100! ^
-e ACCEPT_EULA=Y ^
-p 8081:8081 -p 8901-8902:8901-8902 ^
-p 10250-10255:10250-10255 -p 10350:10350 ^
-p 1433:1433 -p 80:80 ^
-p 10000-10002:10000-10002 ^
-v d:\databases:c:\databases ^
--storage-opt size=150G ^
dockerdatabackend