# This dockerfile utilizes components licensed by their respective owners/authors.
# Prior to utilizing this file or resulting images please review the respective licenses at:
http://www.apache.org/licenses/, https://secure.php.net/license/

FROM mcr.microsoft.com/windows/servercore:2009

LABEL Description="Apache-PHP" Vendor1="Apache Software Foundation" Version1="2.4.38"
Vendor2="The PHP Group" Version2="5.6.40"

RUN powershell -Command \
$ErrorActionPreference = 'Stop'; \
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; \
Invoke-WebRequest -Method Get -Uri
https://github.com/ismartsiva4/containers-windows/raw/main/httpd-2.4.58-win64-VS17.zip -OutFile
c:\apache.zip ; \
Expand-Archive -Path c:\apache.zip -DestinationPath c:\ ; \
Remove-Item c:\apache.zip -Force

RUN powershell -Command \
$ErrorActionPreference = 'Stop'; \
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; \
Invoke-WebRequest -Method Get -Uri
https://github.com/ismartsiva4/containers-windows/raw/main/vc_redist.x64.exe ; \
start-Process c:\vcredist_x86.exe -ArgumentList '/quiet' -Wait ; \
Remove-Item c:\vcredist_x86.exe -Force

RUN powershell -Command \
$ErrorActionPreference = 'Stop'; \
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; \
Invoke-WebRequest -Method Get -Uri
https://windows.php.net/downloads/releases/php-5.6.40-Win32-VC11-x86.zip -OutFile c:\php.zip
; \
Expand-Archive -Path c:\php.zip -DestinationPath c:\php ; \
Remove-Item c:\php.zip -Force

RUN powershell -Command \
$ErrorActionPreference = 'Stop'; \
Remove-Item c:\Apache24\conf\httpd.conf ; \
new-item -Type Directory c:\www -Force ; \
Add-Content -Value "'<?php phpinfo() ?>'" -Path c:\www\index.php

ADD httpd.conf /apache24/conf

WORKDIR /Apache24/bin

CMD /Apache24/bin/httpd.exe -w
