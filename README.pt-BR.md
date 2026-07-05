# ⚡ Disable ZRAM on Boot (Módulo KernelSU / Magisk)

🌎 **Escolha seu idioma:**
[English](README.md) | [Português](README.pt-BR.md) | [Español](README.es.md) | [Русский](README.ru.md) | [中文](README.zh.md)

---

Um utilitário de kernel de baixa latência projetado para **KernelSU e Magisk** para desativar a partição de swap ZRAM (`/dev/block/zram0`) durante o processo de inicialização do Android. Ideal para dispositivos de alta performance para eliminar o overhead de compressão de CPU, reduzir micro-travamentos do sistema e otimizar o consumo de bateria em multitasking severo.

---

## ⚡ Como Funciona

O sistema Android padrão monta e ativa o swap da ZRAM logo após o boot. Este módulo realiza a interceptação de forma segura em duas fases:

1.  **post-fs-data.sh (Fase Precoce):** Executa `swapoff` no `zram0` antes que as páginas de memória comprimida comecem a ser populadas.
2.  **service.sh (Fase de Confirmação):** Aguarda até que a propriedade `sys.boot_completed` seja igual a `1` (indicando o carregamento total da interface gráfica) para validar a estabilidade do boot.

---

## 🛡️ Watchdog de Segurança (Anti-Bootloop)

Desativar o swap do sistema de forma precoce pode, em ROMs customizadas específicas, causar estouro de memória (Out-Of-Memory) e loop de inicialização. Para mitigar isso, o módulo implementa um **watchdog autônomo**:
*   Incrementa um contador de boot persistido em `/data/adb/zram_disable_count` ao iniciar.
*   Reseta o contador para `0` assim que o boot estável for confirmado (`sys.boot_completed=1`).
*   Se o dispositivo falhar em dar boot completo por **3 vezes consecutivas**, o módulo **se autodesabilita** nos próximos boots para restaurar as configurações padrão de ZRAM e permitir a recuperação do sistema.

---

## 📂 Estrutura do Módulo

*   `module.prop`: Metadados do módulo.
*   `post-fs-data.sh`: Script executado em modo root precoce para desativar o swap.
*   `service.sh`: Script de validação de boot estável e reinicialização do watchdog.
*   `index.html`: Simulador interativo de boot com console de logs Android e painel de status do ZRAM.

---

## 🛠️ Instalação

1.  Compacte todos os arquivos da pasta em um arquivo zip:
    ```bash
    zip -r disable-zram-boot.zip . -x "*.git*" "index.html" "server.py"
    ```
2.  Instale o arquivo `.zip` através do aplicativo do **KernelSU**, **APatch** ou **Magisk Manager**.
3.  Reinicie o dispositivo.

---


## 📱 Integração e Monitoramento no Termux
Totalmente compatível com o ambiente Android Termux. Você pode monitorar o status do ZRAM e logs de boot executando:
```bash
su -c "cat /data/adb/disable_zram.log"
```

## 👨‍💻 Créditos
Desenvolvido com 💙 por [Paçoca (@opassoca)](https://github.com/opassoca).
