@echo off
setlocal

:: =============================================================================
:: Script para Escanear y Reparar archivos del sistema Windows
:: Herramientas utilizadas: DISM y SFC
:: Genera un archivo de log con la salida de los comandos.
:: =============================================================================

:: Establecer un título para la ventana de la consola
title Herramienta de Reparacion de Sistema Windows

:: --- Configuracion del Archivo de Log ---
:: Obtener la fecha y hora actual para el nombre del log
:: Formato: Repair_YYYYMMDD_HHMMSS.log
:: Nota: Los caracteres : en %TIME% pueden ser problematicos en nombres de archivo para algunas versiones/configuraciones de CMD.
:: Se reemplazan por nada para asegurar compatibilidad.
set "CURRENT_TIME_FOR_FILENAME=%TIME::=%"
set "CURRENT_TIME_FOR_FILENAME=%CURRENT_TIME_FOR_FILENAME:,=%"
set "CURRENT_DATE_TIME=%date:~-4,4%%date:~3,2%%date:~0,2%_%CURRENT_TIME_FOR_FILENAME:~0,2%%CURRENT_TIME_FOR_FILENAME:~2,2%%CURRENT_TIME_FOR_FILENAME:~4,2%"
set "LOG_FILE_NAME=Repair_%CURRENT_DATE_TIME%.log"
set "LOG_FILE_PATH=%~dp0%LOG_FILE_NAME%"

:: Mensaje inicial
echo Iniciando proceso de escaneo y reparacion del sistema...
echo.
echo La salida de los comandos se guardara en: %LOG_FILE_PATH%
echo.

:: --- Comprobacion de Privilegios de Administrador ---
echo Verificando privilegios de administrador...
net session >nul 2>&1
if %errorlevel% == 0 (
    echo [OK] Privilegios de administrador detectados. Continuando...
) else (
    echo [ERROR] Este script requiere privilegios de administrador.
    echo Por favor, ejecute este script como administrador.
    echo.
    pause
    exit /b 1
)
echo.

:: --- Ejecucion de Comandos de Reparacion ---

:: Paso 1: Ejecutar DISM (Deployment Image Servicing and Management)
echo [INFO] %date% %time% - Iniciando DISM.exe /Online /Cleanup-Image /RestoreHealth >> "%LOG_FILE_PATH%"
echo Ejecutando DISM... Esto puede tardar varios minutos. Por favor, espere.
powershell -NoProfile -Command "DISM.exe /Online /Cleanup-Image /RestoreHealth 2>&1 | Tee-Object -FilePath '%LOG_FILE_PATH%' -Append"
set "DISM_ERROR_LEVEL=%errorlevel%"
echo [INFO] %date% %time% - DISM finalizado. Codigo de salida: %DISM_ERROR_LEVEL% >> "%LOG_FILE_PATH%"
if %DISM_ERROR_LEVEL% neq 0 (
    echo [ADVERTENCIA] DISM finalizo con errores. Revise el log: %LOG_FILE_PATH%
) else (
    echo [OK] DISM completado exitosamente.
)
echo.

:: Paso 2: Ejecutar SFC (System File Checker)
echo [INFO] %date% %time% - Iniciando sfc /scannow >> "%LOG_FILE_PATH%"
echo Ejecutando SFC... Esto tambien puede tardar. Por favor, espere.
powershell -NoProfile -Command "sfc /scannow 2>&1 | Tee-Object -FilePath '%LOG_FILE_PATH%' -Append"
set "SFC_ERROR_LEVEL=%errorlevel%"
echo [INFO] %date% %time% - SFC finalizado. Codigo de salida: %SFC_ERROR_LEVEL% >> "%LOG_FILE_PATH%"
if %SFC_ERROR_LEVEL% neq 0 (
    echo [ADVERTENCIA] SFC finalizo con errores o requirio reinicio. Revise el log: %LOG_FILE_PATH%
) else (
    echo [OK] SFC completado exitosamente.
)
echo.

:: --- Finalizacion y Visualizacion del Log ---
echo [INFO] %date% %time% - Proceso de reparacion finalizado. >> "%LOG_FILE_PATH%"
echo Proceso de escaneo y reparacion finalizado.
echo.
echo Mostrando el contenido del archivo de log:
echo =============================================================================
type "%LOG_FILE_PATH%"
echo =============================================================================
echo.
echo El log completo se ha guardado en: %LOG_FILE_PATH%
echo.

:: Pausar para que el usuario pueda revisar la salida antes de cerrar
pause
exit /b 0
