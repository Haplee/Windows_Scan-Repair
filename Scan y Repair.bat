@echo off
@echo Welcome, thanks for using my sript
PAUSE
@echo Press the Enter key to perform a scan and restore of system files.
PAUSE
DISM.exe /online /cleanup-image /restorehealth
sfc /scannow
@echo All Done
PAUSE
exit

