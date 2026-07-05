# ⚡ Disable ZRAM on Boot (KernelSU / Magisk 模块)

🌎 **选择语言:**
[English](README.md) | [Português](README.pt-BR.md) | [Español](README.es.md) | [Русский](README.ru.md) | [中文](README.zh.md)

---

一个为 **KernelSU 和 Magisk** 设计的低延迟内核实用工具模块，用于在 Android 启动期间禁用 ZRAM 交换分区 (`/dev/block/zram0`)。非常适合高性能设备，以消除 CPU 压缩开销，减少系统微卡顿，并优化高负荷多任务下的电池寿命。

---

## ⚡ 工作原理

默认的 Android 系统会在启动后立即挂载并启用 ZRAM 交换。该模块分两个阶段安全地对其进行拦截：

1.  **post-fs-data.sh (早期阶段):** 在页面开始被填充之前，在 `zram0` 上运行 `swapoff`。
2.  **service.sh (确认阶段):** 等待 `sys.boot_completed` 变为 `1`（表示用户界面已完全加载），以确认启动稳定性。

---

## 🛡️ 安全看门狗 (防开机重启循环 - Anti-Bootloop)

在某些高度定制的 ROM 上，过早禁用系统交换分区可能会触发内存不足 (Out-Of-Memory) 的内核崩溃或开机重启循环。为了防止这种情况，该模块实现了一个**自主看门狗**：
*   在启动时增加保存在 `/data/adb/zram_disable_count` 中的启动计数器。
*   一旦成功确认启动稳定（`sys.boot_completed=1`），将其重置为 `0`。
*   如果设备**连续 3 次**未能完全启动，该模块将在随后的启动中**自动禁用自身**，以恢复默认的 ZRAM 配置并允许系统安全恢复。

---

## 📂 模块结构

*   `module.prop`: 模块元数据。
*   `post-fs-data.sh`: 早期启动 Root 执行脚本。
*   `service.sh`: 启动验证和看门狗重置脚本。
*   `index.html`: 受 Google 启发的交互式 Android 启动日志模拟器和 ZRAM 状态控制面板。

---

## 🛠️ 安装方法

1.  将该目录下的所有文件压缩为一个 zip 文件：
    ```bash
    zip -r disable-zram-boot.zip . -x "*.git*" "index.html" "server.py"
    ```
2.  通过 **KernelSU**、**APatch** 或 **Magisk Manager** 应用程序刷入该 `.zip` 文件。
3.  重启您的设备。

---


## 📱 Termux 集成与监控
完全兼容 Android Termux 环境。您可以通过运行以下命令直接监控 ZRAM 状态和启动日志：
```bash
su -c "cat /data/adb/disable_zram.log"
```


## ⌨️ 快速访问别名 (可选)

要在 Termux 中的任何目录下即时查看 ZRAM 启动日志，请将此别名添加到您的 `~/.bashrc` 中：

```bash
alias zram="su -c 'cat /data/adb/disable_zram.log'"
```

## 👨‍💻 贡献者
由 [Paçoca (@opassoca)](https://github.com/opassoca) 用 💙 开发。
