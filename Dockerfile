FROM microsoft/windowsservercore

WORKDIR c:/
RUN mkdir logs
RUN mkdir db
RUN mkdir clam

SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

RUN (New-Object System.Net.WebClient).DownloadFile('https://www.clamav.net/downloads/production/clamav-0.101.1-win-x64-portable.zip', 'clam.zip') ; `
    Expand-Archive clam.zip -DestinationPath C:\clam ; `
    Remove-Item clam.zip

COPY clamd.conf C:\clam\clamd.conf
COPY freshclam.conf C:\clam\freshclam.conf

WORKDIR c:/clam

RUN freshclam

EXPOSE 3310
ENTRYPOINT [ "clamd" ]


