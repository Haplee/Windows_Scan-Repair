@echo off
setlocal

:: =============================================================================
:: Comprobación de privilegios de administrador
:: =============================================================================
echo Verificando privilegios de administrador...
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo.
    echo ERROR: Este script requiere privilegios de administrador.
    echo Por favor, haz clic derecho sobre el script y selecciona "Ejecutar como administrador".
    echo.
    pause
    exit /b 1
)
echo Privilegios de administrador confirmados.
echo.


:: =============================================================================
:: Configuración del archivo de log con timestamp robusto
:: =============================================================================
echo Configurando archivo de log...
for /f "tokens=2 delims==" %%I in ('wmic os get localdatetime /format:list') do set "datetime=%%I"
set "timestamp=%datetime:~0,8%_%datetime:~8,6%"
set "LOGFILE=%~dp0Repair_%timestamp%.log"
echo El log se guardara en: %LOGFILE%
echo.


:: =============================================================================
:: Inicio del proceso de reparacion
:: =============================================================================
echo Iniciando proceso de reparacion del sistema... > "%LOGFILE%"
echo. >> "%LOGFILE%"


:: =============================================================================
:: Ejecucion de DISM (Deployment Image Servicing and Management)
:: =============================================================================
echo --- Ejecutando DISM ---
echo [INFO] Iniciando DISM.exe /Online /Cleanup-Image /RestoreHealth... >> "%LOGFILE%"
echo.

powershell -NoProfile -Command "DISM.exe /Online /Cleanup-Image /RestoreHealth 2>&1 | Tee-Object -FilePath '%LOGFILE%' -Append"

if %errorlevel% equ 0 (
    echo [SUCCESS] DISM finalizo correctamente. >> "%LOGFILE%"
) else (
    echo [ERROR] DISM finalizo con errores. Codigo de error: %errorlevel% >> "%LOGFILE%"
)
echo. >> "%LOGFILE%"
echo --- DISM finalizado ---
echo.


:: =============================================================================
:: Ejecucion de SFC (System File Checker)
:: =============================================================================
echo --- Ejecutando SFC ---
echo [INFO] Iniciando sfc /scannow... >> "%LOGFILE%"
echo.

powershell -NoProfile -Command "sfc /scannow 2>&1 | Tee-Object -FilePath '%LOGFILE%' -Append"

if %errorlevel% equ 0 (
    echo [SUCCESS] SFC finalizo correctamente. >> "%LOGFILE%"
) else (
    echo [ERROR] SFC finalizo con errores. Codigo de error: %errorlevel% >> "%LOGFILE%"
)
echo. >> "%LOGFILE%"
echo --- SFC finalizado ---
echo.


:: =============================================================================
:: Busqueda de archivos dañados no reparados por SFC
:: =============================================================================
echo --- Buscando archivos dañados... ---
set "CBS_LOG=%windir%\Logs\CBS\CBS.log"
set "DAMAGED_FILES_LOG=%~dp0Damaged_Files.txt"

echo Buscando informacion sobre archivos dañados en "%CBS_LOG%" >> "%LOGFILE%"
findstr /c:"[SR] Cannot repair member file" "%CBS_LOG%" > "%DAMAGED_FILES_LOG%"

if %errorlevel% equ 0 (
    echo [WARNING] Se encontraron archivos dañados que SFC no pudo reparar. >> "%LOGFILE%"
    echo Un registro de los archivos afectados se ha guardado en: "%DAMAGED_FILES_LOG%"
    echo.
    echo ATENCION: Se encontraron archivos que no pudieron ser reparados.
    echo Revisa el archivo "%DAMAGED_FILES_LOG%" para mas detalles.
) else (
    echo [INFO] No se encontraron archivos dañados que no pudieran ser reparados por SFC. >> "%LOGFILE%"
    if exist "%DAMAGED_FILES_LOG%" del "%DAMAGED_FILES_LOG%"
)
echo --- Busqueda finalizada ---
echo.


:: =============================================================================
:: Finalizacion y visualizacion del log
:: =============================================================================
echo Proceso de reparacion completado.
echo Mostrando el log generado:
echo.
echo =============================================================================
type "%LOGFILE%"
echo =============================================================================
echo.
echo El log completo ha sido guardado en "%LOGFILE%"
pause
exit /b 0
