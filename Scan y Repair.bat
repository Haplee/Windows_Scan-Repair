@echo off
setlocal

:: Nombre de log
set "LOG=%~dp0Repair_%date:~-4,4%%date:~3,2%%date:~0,2%_%time:~0,2%%time:~3,2%%time:~6,2%.log"

echo Iniciando restauración del sistema...

:: Ejecutar DISM con Tee-Object
powershell -NoProfile -Command "DISM.exe /Online /Cleanup-Image /RestoreHealth 2>&1 | Tee-Object -FilePath '%LOG%' -Append"

:: Ejecutar SFC con Tee-Object
powershell -NoProfile -Command "sfc /scannow 2>&1 | Tee-Object -FilePath '%LOG%' -Append"

echo Proceso finalizado.
echo.
type "%LOG%"
pause >nul
exit /b 0
