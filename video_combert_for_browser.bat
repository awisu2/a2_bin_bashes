@echo off
setlocal

set "BASH=C:\Program Files\Git\bin\bash.exe"
set "SCRIPT=%~dp0video_combert_for_browser.sh"

"%BASH%" "%SCRIPT%" files %*

endlocal
pause