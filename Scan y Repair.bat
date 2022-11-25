@echo Presiona la tecla Enter para relizar un scaner y una restauracion de archivos del sistema
PAUSE
DISM.exe /online /cleanup-image /restorehealth
sfc /scannow
@echo Hecho
PAUSE
exit

