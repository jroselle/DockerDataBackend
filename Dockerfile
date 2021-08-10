# Data backend for developers
# Install Comsmo, SQL Server, SSRS, Azurite
# B/C Docker doesnt play well yet with both linux and windows vms, stick everything
#  in Windows VM

# Indicates that the windowsservercore image will be used as the base image.
FROM mcr.microsoft.com/windows/servercore:20H2

# Metadata indicating an image maintainer.
LABEL Name=DataBackend Version=0.0.4 maintainer="jroselle@clearsparc.com"

# environment variables
ENV sa_password="replacedInRun123!" \
    ACCEPT_EULA="Y" \
    ssrs_user="bob" \
    ssrs_password="replacedInRun123!"

# Add the CosmosDB installer msi into the package
ADD https://aka.ms/cosmosdb-emulator AzureCosmosDB.Emulator.msi

# Direct download links for SQL Server 2019 Developer
ADD https://download.microsoft.com/download/7/c/1/7c14e92e-bdcb-4f89-b7cf-93543e7112d1/SQLServer2019-DEV-x64-ENU.exe SQL.exe
ADD https://download.microsoft.com/download/7/c/1/7c14e92e-bdcb-4f89-b7cf-93543e7112d1/SQLServer2019-DEV-x64-ENU.box SQL.box

# SSRS installer
ADD https://download.microsoft.com/download/1/a/a/1aaa9177-3578-4931-b8f3-373b24f63342/SQLServerReportingServices.exe SQLServerReportingServices.exe

# NODE installer
ADD https://nodejs.org/dist/v6.11.1/node-v6.11.1-x64.msi node.msi

# Use the packages folder instead of the direct links above
# Packages should contain
#  node.msi - latest node installer
#  AzureCosmosDB.Emulator.msi
#  SQLServerReportingService.exe
#  SQL.exe - SQL Server to install
#  SQL.box - the box files - I cannot seem to find a direct link
# COPY packages\\* /


# Copy misc scripts into the package
COPY package_scripts\\* /

# Expose the required network ports - Cosmos
EXPOSE 8081
EXPOSE 8901-8902
EXPOSE 10250-10255
EXPOSE 10350

# SQL Server
EXPOSE 1433

# SSRS
EXPOSE 80

# Azurite
EXPOSE 10000-10002


# set our shell to powershell
SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

# make install files accessible
WORKDIR /

RUN .\installNode.ps1 ; \
        .\installCosmosEmulator.ps1 ; \
        .\installSqlServer.ps1 ; 

HEALTHCHECK CMD [ "sqlcmd", "-Q", "select 1" ]

# Start the interactive shell
CMD [ "c:\\startMeUp.cmd" ]
