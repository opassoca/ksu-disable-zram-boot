# ⚡ Disable ZRAM on Boot (KernelSU / Magisk Module)

🌎 **Choose your language:**
[English](README.md) | [Português](README.pt-BR.md) | [Español](README.es.md) | [Русский](README.ru.md) | [中文](README.zh.md)

---

A low-latency kernel utility module designed for **KernelSU and Magisk** to disable ZRAM swap (`/dev/block/zram0`) during Android startup. Perfect for high-performance devices to eliminate CPU compression overhead, reduce system micro-stutters, and optimize multitasking battery life.

---

## ⚡ How It Works

The default Android system mounts ZRAM swap right after boot. This module intercepts it safely in two phases:

1.  **post-fs-data.sh (Early Phase):** Runs `swapoff` on `zram0` before pages can be populated.
2.  **service.sh (Verification Phase):** Waits for `sys.boot_completed` to hit `1` (indicating full UI load) and confirms boot stability.

---

## 🛡️ Watchdog Safeguard (Anti-Bootloop)

Disabling system swap early can trigger Out-Of-Memory kernel panics or bootloops on some heavily customized ROMs. To prevent this, the module implements an **autonomous watchdog**:
*   Increments a boot counter stored in `/data/adb/zram_disable_count` at startup.
*   Resets it to `0` once `sys.boot_completed` is successfully confirmed.
*   If the system fails to boot completely for **3 consecutive times**, the module **permanently disables itself** on subsequent boots to restore stock ZRAM configuration.

---

## 📂 Module Structure

*   `module.prop`: Module metadata.
*   `post-fs-data.sh`: Early boot root execution script.
*   `service.sh`: Boot validation and watchdog reset script.
*   `index.html`: Interactive Google-inspired Android boot log simulator and dashboard.

---

## 🛠️ Installation

1.  Zip all files in the directory:
    ```bash
    zip -r disable-zram-boot.zip . -x "*.git*" "index.html" "server.py"
    ```
2.  Flash the `.zip` file via **KernelSU**, **APatch**, or **Magisk Manager**.
3.  Reboot your device.

---


## 📱 Termux Integration & Monitoring
Fully compatible with Android Termux environment. You can monitor the ZRAM status and boot logs directly by running:
```bash
su -c "cat /data/adb/disable_zram.log"
```


## ⌨️ Fast Access Alias (Optional)

To check the ZRAM boot logs instantly from any directory in Termux, add this alias to your `~/.bashrc`:

```bash
alias zram="su -c 'cat /data/adb/disable_zram.log'"
```

## 👨‍💻 Credits
Developed with 💙 by [Paçoca (@opassoca)](https://github.com/opassoca).
