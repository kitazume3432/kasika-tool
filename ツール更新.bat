@echo off
setlocal
pushd "%~dp0"
if errorlevel 1 goto :nofolder

set "LOGFILE=%cd%\update_log.txt"
echo ============================================== >> "%LOGFILE%"
echo Update started: %date% %time% >> "%LOGFILE%"

echo ===============================================
echo   kasika-tool update - pushing to GitHub
echo   Folder: %cd%
echo ===============================================
echo.

git pull --quiet

set "DOWNLOADS=%USERPROFILE%\Downloads"
set "NEWEST="
for /f "delims=" %%F in ('dir /b /o-d /a-d "%DOWNLOADS%\kasika-mailmag-list*.html" 2^>nul') do (
  if not defined NEWEST set "NEWEST=%%F"
)
if not defined NEWEST goto :nofile

echo Newest tool file in Downloads:
echo   %NEWEST%
for %%A in ("%DOWNLOADS%\%NEWEST%") do echo   Downloaded: %%~tA
echo.
set "CONFIRM="
set /p CONFIRM="Overwrite index.html with this file? (Y / N): "
if /i not "%CONFIRM%"=="Y" goto :skipcopy

copy /Y "%DOWNLOADS%\%NEWEST%" "index.html" >nul
if errorlevel 1 goto :copyfailed
echo index.html updated.
echo Overwrote index.html with: %NEWEST% >> "%LOGFILE%"
goto :commit

:nofile
echo No "kasika-mailmag-list*.html" found in Downloads.
echo Uploading the files already in this folder.
echo No tool file in Downloads. >> "%LOGFILE%"
goto :commit

:skipcopy
echo Skipped overwrite.
echo Skipped overwrite. >> "%LOGFILE%"
goto :commit

:copyfailed
echo [ERROR] Could not copy the file to index.html.
echo [ERROR] copy failed >> "%LOGFILE%"
goto :end

:commit
echo.
git add -A
git commit -m "update %date% %time%" >> "%LOGFILE%" 2>&1
if errorlevel 1 goto :nochange
echo Uploading to GitHub...
git push origin main >> "%LOGFILE%" 2>&1
if errorlevel 1 goto :pushfailed
echo.
echo Update completed successfully.
echo It will be live in 1-2 minutes:
echo   https://kitazume3432.github.io/kasika-tool/
echo PUSH SUCCESS >> "%LOGFILE%"
goto :end

:nochange
echo No changes to upload.
echo No changes. >> "%LOGFILE%"
goto :end

:pushfailed
echo [ERROR] Push failed. Check network / GitHub login. Details: update_log.txt
echo PUSH FAILED >> "%LOGFILE%"
goto :end

:nofolder
echo [ERROR] Could not open folder: %~dp0
pause
exit /b 1

:end
echo.
pause
popd
endlocal
