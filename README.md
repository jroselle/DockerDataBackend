# Data back end

Creates a windows docker container with SQL Server 2019 Developer, SSRS, Cosmos Emulator, Azurite Storage emulator.

This was hobbled together by reviewing the work of others and tailoring it to what I needed.



## Run it

docker run --name DataBackend --dns 8.8.8.8 ^ \
-e sa_password=ReplaceMe100! ^ \
-e ssrs_user=bob ^ \
-e ssrs_password=ReplaceMe100! ^ \
-e ACCEPT_EULA=Y ^ \
-p 8081:8081 -p 8901-8902:8901-8902 ^ \
-p 10250-10255:10250-10255 -p 10350:10350 ^ \
-p 1443:1443 -p 80:80 ^ \
-p 10000-10002:10000-10002 ^ \
--storage-opt size=150G ^ \
--memory 6g ^ \
dockerdatabackend


## Disclaimers

DO NOT USE IN PRODUCTION!  Designed for developers to encapsulate the backend.

## Credits

- https://github.com/phola/SSRS-Docker
- https://gist.github.com/SvenAelterman/f2fd058bf3a8aa6f37ac69e5d5dd2511
- https://github.com/Azure/azure-cosmos-db-emulator-docker
- https://github.com/Azure/Azurite

## License

MIT license. See the [LICENSE file](LICENSE) for more details.
