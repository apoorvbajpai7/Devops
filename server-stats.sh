#!/bin/bash

echo "===== Server Performance Stats ====="

# CPU Usage
echo
echo "🔧 CPU Usage:"
CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | awk '{print 100 - $8"%"}')
echo "Total CPU Usage: $CPU_USAGE"

# Memory Usage
echo
echo "🧠 Memory Usage:"
MEM_TOTAL=$(free -m | awk '/Mem:/ {print $2}')
MEM_USED=$(free -m | awk '/Mem:/ {print $3}')
MEM_FREE=$(free -m | awk '/Mem:/ {print $4}')
MEM_PERCENT=$(free | awk '/Mem:/ {printf("%.2f%%", $3/$2 * 100)}')

echo "Total Memory: ${MEM_TOTAL} MB"
echo "Used Memory: ${MEM_USED} MB"
echo "Free Memory: ${MEM_FREE} MB"
echo "Memory Usage: ${MEM_PERCENT}"

# Disk Usage
echo
echo "💾 Disk Usage:"
DISK_INFO=$(df -h --total | grep 'total')
DISK_USED=$(echo "$DISK_INFO" | awk '{print $3}')
DISK_AVAIL=$(echo "$DISK_INFO" | awk '{print $4}')
DISK_PERCENT=$(echo "$DISK_INFO" | awk '{print $5}')

echo "Total Disk Used: $DISK_USED"
echo "Total Disk Available: $DISK_AVAIL"
echo "Disk Usage: $DISK_PERCENT"

# Top 5 Processes by CPU
echo
echo "🔥 Top 5 Processes by CPU Usage:"
ps -eo pid,comm,%cpu,%mem --sort=-%cpu | head -n 6

# Top 5 Processes by Memory
echo
echo "💡 Top 5 Processes by Memory Usage:"
ps -eo pid,comm,%cpu,%mem --sort=-%mem | head -n 6

echo
echo "===== End of Report ====="

