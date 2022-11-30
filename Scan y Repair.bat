@echo off
PAUSE
DISM.exe /online /cleanup-image /restorehealth
sfc /scannow
PAUSE
exit

