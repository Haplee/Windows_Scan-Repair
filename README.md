## 📄 Nombre del proyecto

**Windows-Repair-Batch**  

## 📝 Descripción

Este proyecto proporciona un archivo `.bat` que automatiza el escaneo y la restauración de la imagen del sistema Windows usando DISM y SFC, guardando un log con fecha y hora para auditoría. Está pensado para administradores y usuarios avanzados que necesiten reparar sistemas de forma repetible y documentada.

## ⚙️ Características

- Comprueba y exige ejecución con privilegios de administrador antes de continuar.  
- Ejecuta `DISM.exe /Online /Cleanup-Image /RestoreHealth` y `sfc /scannow` automáticamente.  
- Genera un fichero de log con timestamp en nombre (`YYYYMMDD_HHMMSS.log`) para cada ejecución.  
- Muestra por pantalla y almacena tanto la salida estándar como los errores (stdout/stderr) usando redirección nativa de CMD (`>> log 2>&1`).  
- Al final, despliega el contenido del log con `type`, sin depender de utilidades externas.

## 🛠 Requisitos previos

- Windows 7 o superior con DISM y SFC incluidos.  
- Privilegios de administrador para poder ejecutar correctamente las herramientas de reparación.

## 🚀 Instalación

1. Clona o descarga el repositorio:  
   ```bash
   git clone https://github.com/Haplee/Windows-Repair-Batch.git
   ```  
2. Sitúate en la carpeta creada:  
   ```bash
   cd Windows-Repair-Batch
   ```  
3. (Opcional) Personaliza rutas o nombres de log en el propio `.bat`.

## ▶️ Uso

Desde una consola con “Ejecutar como administrador”:

```bat
RepairSystem.bat
```

- El script verificará privilegios, ejecutará DISM y SFC, y volcará un log en la misma carpeta.  
- Al terminar, mostrará el contenido del log y esperará a que pulses una tecla para cerrar.

## 📂 Estructura del repositorio

```
Windows-Repair-Batch/
├── RepairSystem.bat    # Script principal
└── README.md           # Este archivo
```

## 🐞 Control de errores

- Se comprueba `%errorlevel%` tras cada comando para detectar fallos y registrarlos en el log.  
- Si no hay privilegios de administrador, el script avisa y sale con código de error `1`.  
