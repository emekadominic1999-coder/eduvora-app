@echo off
title Eduvora
cd /d "%~dp0"

echo Starting Eduvora...
echo (This window will show progress. A Chrome window will open when it is ready.)
echo.

call flutter pub get
call flutter run -d chrome

echo.
echo Eduvora has stopped.
pause
