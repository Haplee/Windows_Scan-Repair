# 📄 Windows Repair Batch

## 📝 Descripción

Este proyecto proporciona un script de batch (`.bat`) avanzado para automatizar el escaneo y la reparación de archivos del sistema en Windows. Utiliza las herramientas nativas **DISM** y **SFC** y ha sido diseñado para ser robusto, informativo y seguro.

El script realiza una comprobación de privilegios, ejecuta las herramientas de reparación, guarda un log detallado de toda la operación y, además, analiza los resultados de SFC para extraer una lista de archivos que no pudieron ser reparados, facilitando el diagnóstico y la intervención manual.

## ✨ Características Principales

- **Verificación de Administrador**: El script comprueba si se está ejecutando con privilegios de administrador y, en caso contrario, se detiene con un mensaje de error.
- **Reparación en Dos Fases**:
  1. Ejecuta `DISM.exe /Online /Cleanup-Image /RestoreHealth` para reparar la imagen del sistema de Windows.
  2. Ejecuta `sfc /scannow` para verificar y reparar los archivos del sistema utilizando la imagen reparada.
- **Logging Detallado**:
  - Genera un archivo de log principal (`Repair_YYYYMMDD_HHMMSS.log`) con la salida completa de los comandos DISM y SFC.
  - El timestamp en el nombre del log se genera de forma robusta con `wmic`, evitando problemas con la configuración regional.
- **Detección de Archivos Dañados**:
  - Después del escaneo SFC, el script analiza el log de `CBS` (`%windir%\Logs\CBS\CBS.log`).
  - Si encuentra archivos que SFC no pudo reparar, crea un archivo adicional `Damaged_Files.txt` con los detalles para una fácil identificación.
- **Manejo de Errores**: Comprueba el código de salida (`%errorlevel%`) después de cada operación crítica (DISM y SFC) y lo anota en el log.
- **Feedback en Tiempo Real**: Utiliza PowerShell `Tee-Object` para mostrar la salida de los comandos en la consola en tiempo real mientras se guarda en el archivo de log.

## 🛠 Requisitos

- Windows 7 o superior.
- PowerShell 2.0 o superior (para la función de `Tee-Object`).
- Privilegios de administrador para ejecutar el script.

## 🚀 Uso

1. Descarga el archivo `RepairSystem.bat`.
2. Haz clic derecho sobre `RepairSystem.bat` y selecciona **"Ejecutar como administrador"**.
3. El script comenzará el proceso de verificación y reparación. La duración puede ser considerable (15-30 minutos o más).
4. Una vez finalizado, el script mostrará el contenido del log principal en la consola.
5. Si se detectaron archivos que no se pudieron reparar, aparecerá un mensaje de **ATENCIÓN** en la consola y se creará el archivo `Damaged_Files.txt` en la misma carpeta.

## 📂 Estructura de Archivos (Ejemplo de salida)

```
Windows-Repair-Batch/
├── RepairSystem.bat               # El script principal
├── Repair_20231027_103000.log     # Archivo de log de una ejecución
├── Damaged_Files.txt              # (Opcional) Creado solo si SFC no puede reparar archivos
└── README.md                      # Este archivo
```

## 🐞 Control de Errores

- **Sin privilegios de administrador**: El script muestra un mensaje de error y sale con el código `1`.
- **Errores en DISM/SFC**: El script no se detiene, pero anota en el log si `DISM` o `SFC` finalizaron con un código de error, permitiendo un diagnóstico posterior.
- **Archivos no reparados**: Se genera `Damaged_Files.txt` para que el usuario pueda identificar qué archivos requieren atención manual.
