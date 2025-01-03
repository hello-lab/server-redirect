@echo off

REM Variables
set CLOUDFLARE_TUNNEL_EXECUTABLE=cloudflared.exe
set CLOUDFLARE_TUNNEL_COMMAND=tunnel
set TARGET_SERVER=http://localhost:3000
set TUNNEL_LOG_FILE=kuhh.log

REM Start Cloudflare Tunnel in the background and redirect output to a log file
start /b %CLOUDFLARE_TUNNEL_EXECUTABLE% %CLOUDFLARE_TUNNEL_COMMAND% --url http://localhost:8096 > %TUNNEL_LOG_FILE% 2>&1

REM Wait for the log file to contain the tunnel URL
:wait_for_url
timeout /t 10 > nul
findstr /i "trycloudflare" %TUNNEL_LOG_FILE% > nul
if errorlevel 1 goto wait_for_url

setlocal EnableDelayedExpansion

REM Extract the URL from the log file
set helloworld=1
for /f "tokens=*" %%i in ('findstr /i "trycloudflare" %TUNNEL_LOG_FILE%') do (
    echo %%i
if !helloworld!==2 (
    echo !helloworld!
        set TUNNEL_URL=%%i
        goto url_found
    
   
    ) else (
        echo The variable helloworld equals 1.
    set /a helloworld=!helloworld!+1
    )
)
:url_found

REM Send the URL to the server
curl -X POST -H "Content-Type: application/json" -d "{\"url\":\"!TUNNEL_URL!\"}" %TARGET_SERVER%/tunnel-url

REM Close the log file
call :close_log_file

REM Notify completion
echo Cloudflare Tunnel URL sent: %TUNNEL_URL%
pause

:close_log_file
REM Close the log file by redirecting to nul

exit /b
