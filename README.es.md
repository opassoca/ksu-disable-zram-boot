# ⚡ Disable ZRAM on Boot (Módulo KernelSU / Magisk)

🌎 **Seleccione su idioma:**
[English](README.md) | [Português](README.pt-BR.md) | [Español](README.es.md) | [Русский](README.ru.md) | [中文](README.zh.md)

---

Una utilidad de kernel de baja latencia diseñada para **KernelSU y Magisk** para desactivar la partición de swap ZRAM (`/dev/block/zram0`) durante el proceso de arranque de Android. Ideal para dispositivos de alto rendimiento para eliminar la sobrecarga de compresión de la CPU, reducir micro-tirones del sistema y optimizar el consumo de batería en multitarea pesada.

---

## ⚡ Cómo Funciona

El sistema Android por defecto monta y activa el swap de la ZRAM justo después del arranque. Este módulo realiza la interceptación de forma segura en dos fases:

1.  **post-fs-data.sh (Fase Temprana):** Ejecuta `swapoff` en `zram0` antes de que las páginas de memoria comprimida comiencen a poblarse.
2.  **service.sh (Fase de Confirmación):** Espera hasta que la propiedad `sys.boot_completed` sea igual a `1` (indicando el inicio de la interfaz de usuario) para validar la estabilidad del arranque.

---

## 🛡️ Watchdog de Seguridad (Anti-Bootloop)

Desactivar el swap del sistema de forma temprana puede, en algunas ROMs personalizadas, causar pánicos de kernel por falta de memoria (Out-Of-Memory) o bucles de arranque. Para mitigar esto, el módulo implementa un **watchdog autónomo**:
*   Incrementa un contador de arranque persistido en `/data/adb/zram_disable_count` al iniciar.
*   Restablece el contador a `0` tan pronto como se confirma un arranque estable (`sys.boot_completed=1`).
*   Si el dispositivo no logra arrancar completamente durante **3 veces consecutivas**, el módulo **se desactiva automáticamente** en los próximos arranques para restaurar la configuración predeterminada de ZRAM y permitir la recuperación del sistema.

---

## 📂 Estructura del Módulo

*   `module.prop`: Metadatos del módulo.
*   `post-fs-data.sh`: Script ejecutado en modo root temprano para desactivar el swap.
*   `service.sh`: Script de validación de arranque estable y reinicio del watchdog.
*   `index.html`: Simulador interactivo de arranque con consola de registros Android y panel de estado de ZRAM.

---

## 🛠️ Instalación

1.  Comprima todos los archivos en un archivo zip:
    ```bash
    zip -r disable-zram-boot.zip . -x "*.git*" "index.html" "server.py"
    ```
2.  Instale el archivo `.zip` a través de la aplicación **KernelSU**, **APatch** o **Magisk Manager**.
3.  Reinicie el dispositivo.

---

## 👨‍💻 Créditos
Desarrollado con 💙 por [Paçoca (@opassoca)](https://github.com/opassoca).
