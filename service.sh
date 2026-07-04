#!/system/bin/sh
# ============================================
# disable_zram_boot / service.sh
# Confirma boot bem-sucedido e reseta contador (swapoff ja roda no post-fs-data)
# ============================================

COUNTER_FILE=/data/adb/zram_disable_count
LOG_FILE=/data/adb/zram_disable.log

log() {
    TS=$(date +%H:%M:%S)
    echo "[$TS] $1" >> "$LOG_FILE"
    [ "$(wc -l < "$LOG_FILE" 2>/dev/null)" -gt 200 ] 2>/dev/null && { tail -n 100 "$LOG_FILE" > "$LOG_FILE.tmp" && mv "$LOG_FILE.tmp" "$LOG_FILE"; }
}

MAX_WAIT=180
ELAPSED=0
while [ "$ELAPSED" -lt "$MAX_WAIT" ]; do
    [ "$(getprop sys.boot_completed)" = "1" ] && break
    sleep 5
    ELAPSED=$((ELAPSED+5))
done

if [ "$(getprop sys.boot_completed)" = "1" ]; then
    echo "0" > "$COUNTER_FILE"
    log "Boot bem-sucedido confirmado apos ${ELAPSED}s. Contador resetado."
else
    log "AVISO: boot_completed nao detectado apos ${MAX_WAIT}s"
fi
