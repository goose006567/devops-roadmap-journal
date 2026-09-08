#!/bin/bash

# Server Health Check Script

# Day 2: Basic system monitoring

# Configuration
LOG_FILE="healthcheck.log"
PROCESS_NAME="${1:-sshd}"  # Default to sshd if no argument given
DISK_THRESHOLD=80

echo "=== Server Health Check ==="
echo "Timestamp: $(date)"
echo ""

# 1. Check Disk Usage (flag if > 80%)
echo "--- Disk Usage Check ---"
disk_alert=""
df -h | awk 'NR>1 {print $5, $6}' | while read -r usage mount; do
    usage_num=${usage%\%}
    if [ "$usage_num" -gt "$DISK_THRESHOLD" ]; then
        echo "WARNING: $mount is ${usage} full (threshold: ${DISK_THRESHOLD}%)"
    else
        echo "OK: $mount is ${usage} full"
    fi
done

# Capture disk status for log (highest usage)
max_usage=$(df -h | awk 'NR>1 {print $5}' | sed 's/%//' | sort -n | tail -1)
if [ "$max_usage" -gt "$DISK_THRESHOLD" ]; then
    disk_status="ALERT: Disk ${max_usage}% full"
else
    disk_status="OK: Disk ${max_usage}% used"
fi
echo "$disk_status"
echo ""

# 2. Check Memory Usage
echo "--- Memory Usage ---"
mem_info=$(free -m | awk 'NR==2{printf "Total: %sMB, Used: %sMB, Free: %sMB, Usage: %.2f%%", $2, $3, $4, $3*100/$2 }')
echo "$mem_info"
mem_percent=$(free -m | awk 'NR==2{print int($3*100/$2)}')
echo ""

# 3. Check Process
echo "--- Process Check: $PROCESS_NAME ---"
if ps aux | grep -v grep | grep -q "$PROCESS_NAME"; then
    proc_status="RUNNING"
    echo "Status: $PROCESS_NAME is running"
else
    proc_status="NOT RUNNING"
    echo "WARNING: $PROCESS_NAME is not running"
fi
echo ""

# 4. Log Summary (timestamped)
log_entry="$(date '+%Y-%m-%d %H:%M:%S') | DISK: ${max_usage}% | MEM: ${mem_percent}% | PROC: ${PROCESS_NAME}=${proc_status}"
echo "$log_entry" >> "$LOG_FILE"
echo "Logged to $LOG_FILE:"
echo "$log_entry"
