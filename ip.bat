@echo off
rem *********************************************************************
rem *   This batch file does a scan of an IP range and outputs a list   *
rem *      of all the active pings, mac addresses and hostnames.        *
rem *                                                                   *
rem *       Created By Alex Garwood, Version 0.1 (12/07/2016)           *
rem *                                                                   *
rem *********************************************************************
rem 
rem Edit the IP range here. By default it will go up to .254

set ip=192.168.1

rem Leave everything else below this line.

set /a n=0
del "ipaddresses.txt" /s
del "temp1.txt" /s
del "temp2.txt" /s
set TAB=          

:repeat

set /a n+=1
echo %ip%.%n%
ping -n 1 -w 500  %ip%.%n% | find "TTL"
if not errorlevel 1 goto details
if %n% lss 254 goto repeat
type ipaddresses.txt
goto exit

:details

rem arp - a | find %ip%.%n%
nslookup %ip%.%n% | find "Name" > temp1.txt
nbtstat -a %ip%.%n% | find "MAC" > temp2.txt
set /p HostNa=<temp1.txt
set /p Macadd=<temp2.txt
echo %HostNa% %TAB% %ip%.%n% %TAB% %Macadd% %TAB% >> ipaddresses.txt
if %n% lss 254 goto repeat

:exit

del "temp1.txt" /s
del "temp2.txt" /s
pause