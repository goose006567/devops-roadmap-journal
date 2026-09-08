#!/bin/bash
# Server Health Check Script
# Day 2: Basic system monitoring

echo "=== Server Health Check ==="
echo "Date: $(date)"
echo ""

# CPU Usage
echo "--- CPU Usage ---"
top -l 1 | grep "CPU usage" 2>/dev/null || top -bn1 | grep "Cpu(s)"

# Memory
echo "--- Memory Usage ---"
free -h 2>/dev/null || vm_stat

# Disk Space
echo "--- Disk Space ---"
df -h

# Uptime
echo "--- Uptime ---"
uptime
