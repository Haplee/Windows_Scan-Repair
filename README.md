## 📄 Nombre del proyecto

**Windows-Repair-Batch**

## 📝 Descripción

Este proyecto proporciona un archivo `.bat` (actualmente llamado `Scan y Repair.bat`) que automatiza el escaneo y la restauración de la imagen del sistema Windows usando las herramientas DISM y SFC. Guarda un log detallado con fecha y hora para auditoría de cada ejecución. Está pensado para administradores de sistemas y usuarios avanzados que necesiten una forma rápida y documentada de realizar tareas de mantenimiento y reparación en Windows.

## ⚙️ Características Actualizadas

- **Comprobación de Privilegios:** Verifica si el script se ejecuta con privilegios de administrador y se detiene con un mensaje claro si no es así.
- **Ejecución Automatizada de DISM y SFC:**
    - Ejecuta `DISM.exe /Online /Cleanup-Image /RestoreHealth`.
    - Ejecuta `sfc /scannow`.
- **Generación de Logs Detallados:**
    - Crea un archivo de log único para cada ejecución con formato de nombre `Repair_YYYYMMDD_HHMMSS.log` en la misma carpeta del script.
    - Utiliza `Tee-Object` de PowerShell para mostrar la salida de los comandos en la consola en tiempo real *y* guardarla en el archivo de log.
    - Registra mensajes informativos (`[INFO]`, `[OK]`, `[ADVERTENCIA]`) y los códigos de salida de DISM y SFC en el log.
- **Información en Consola:**
    - Muestra el progreso y los resultados resumidos (éxito o advertencia de error) de DISM y SFC en la consola.
    - Al finalizar, muestra el contenido completo del archivo de log en la consola.
- **Manejo de Nombres de Archivo:** Gestiona correctamente los caracteres especiales de la variable `%TIME%` para asegurar la compatibilidad en la creación de nombres de log.
- **Pausa Final:** El script espera a que el usuario presione una tecla antes de cerrar la ventana de la consola, permitiendo la revisión de la salida.

## 🛠 Requisitos previos

- Windows 7 o superior (con PowerShell disponible para la funcionalidad `Tee-Object`).
- Privilegios de administrador para ejecutar el script y las herramientas de reparación (`DISM`, `SFC`).

## 🚀 Instalación

1.  Clona o descarga el repositorio. Por ejemplo, usando Git:
    ```bash
    git clone https://github.com/Haplee/Windows-Repair-Batch.git
    ```
2.  Navega a la carpeta del proyecto:
    ```bash
    cd Windows-Repair-Batch
    ```
3.  (Opcional) Puedes revisar o personalizar el script `Scan y Repair.bat` si es necesario, aunque está diseñado para funcionar directamente.

## ▶️ Uso

1.  Abre una ventana de Símbolo del sistema (CMD) o PowerShell **como Administrador**.
2.  Navega hasta el directorio donde guardaste `Scan y Repair.bat`.
3.  Ejecuta el script:
    ```bat
    .\Scan y Repair.bat
    ```
    o simplemente:
    ```bat
    "Scan y Repair.bat"
    ```

- El script primero verificará los privilegios de administrador.
- Luego, ejecutará DISM y SFC. Verás la salida en tiempo real.
- Se creará un archivo `Repair_YYYYMMDD_HHMMSS.log` en la misma carpeta con todos los detalles.
- Al finalizar, el contenido del log se mostrará en la consola y el script esperará a que presiones una tecla.

## 📂 Estructura del repositorio (Actual)

```
Windows-Repair-Batch/
├── Scan y Repair.bat   # Script principal mejorado
└── README.md           # Este archivo
```
*Nota: El nombre del script en el repositorio es `Scan y Repair.bat`. El `README.md` anterior mencionaba `RepairSystem.bat`.*

## 🐞 Control de errores

- **Privilegios de Administrador:** El script no se ejecutará sin ellos y mostrará un mensaje de error.
- **Errores de DISM/SFC:**
    - El script captura el código de salida (`%errorlevel%`) de DISM y SFC.
    - Muestra un mensaje de `[OK]` o `[ADVERTENCIA]` en la consola basado en el código de salida.
    - Registra el código de salida específico en el archivo de log para una depuración detallada.
    - La salida completa (stdout y stderr) de los comandos se guarda en el log, permitiendo un análisis posterior de cualquier problema.

## 💡 Mejoras Realizadas

- Añadida comprobación explícita de privilegios de administrador.
- Mejorada la legibilidad del script con más comentarios y una estructura más clara.
- Variables renombradas para mayor claridad (e.g., `LOG` a `LOG_FILE_PATH`).
- Manejo robusto de la variable `%TIME%` para la creación de nombres de archivo de log.
- Registro explícito de los códigos de error de DISM y SFC en el log y mensajes en consola.
- Actualización de este `README.md` para reflejar el estado actual y las funcionalidades del script.
- Título añadido a la ventana de la consola.
- Mensajes informativos mejorados durante la ejecución del script.
