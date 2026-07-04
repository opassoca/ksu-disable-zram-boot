#!/system/bin/sh
# ============================================
# disable_zram_boot / post-fs-data.sh
# Roda swapoff o mais cedo possivel no boot (antes do sistema popular o zram)
# Incrementa contador de boots; sinaliza autodesabilitacao apos 3 falhas
# ============================================

COUNTER_FILE=/data/adb/zram_disable_count
OFF_FLAG=/data/adb/zram_disable_module_off
LOG_FILE=/data/adb/zram_disable.log

log() {
    TS=$(date +%H:%M:%S)
    echo "[$TS] $1" >> "$LOG_FILE"
    [ "$(wc -l < "$LOG_FILE" 2>/dev/null)" -gt 200 ] 2>/dev/null && { tail -n 100 "$LOG_FILE" > "$LOG_FILE.tmp" && mv "$LOG_FILE.tmp" "$LOG_FILE"; }
}

if [ -f "$OFF_FLAG" ]; then
    log "Modulo desabilitado (3 falhas previas) -- swapoff pulado"
else
    swapoff /dev/block/zram0 2>/dev/null
    log "swapoff executado (post-fs-data, inicio do boot)"
fi

[ -f "$COUNTER_FILE" ] || echo 0 > "$COUNTER_FILE"
COUNT=$(cat "$COUNTER_FILE")
COUNT=$((COUNT+1))
echo "$COUNT" > "$COUNTER_FILE"
log "Boot #$COUNT sem confirmacao anterior"

if [ "$COUNT" -ge 3 ]; then
    touch "$OFF_FLAG"
    log "3 boots sem sucesso confirmado -- modulo autodesabilitado, proximos boots pulam swapoff"
fi
