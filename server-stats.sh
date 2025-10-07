#!/bin/bash

echo "===== 🖥️  Server Performance Report ====="
echo "Generated on: $(date)"
echo

# ---------- OS & System Info ----------
echo "🔧 System Information:"
echo "Hostname         : $(hostname)"
echo "OS Version       : $(lsb_release -d | cut -f2-)"
echo "Kernel Version   : $(uname -r)"
echo "System Uptime    : $(uptime -p)"
echo "Load Average     : $(uptime | awk -F'load average: ' '{ print $2 }')"
echo "Logged-in Users  : $(who | wc -l)"
echo

# ---------- CPU Usage ----------
echo "🧠 CPU Usage:"
CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | awk '{print 100 - $8"%"}')
echo "Total CPU Usage  : $CPU_USAGE"
echo

# ---------- Memory Usage ----------
echo "💾 Memory Usage:"
MEM_TOTAL=$(free -m | awk '/Mem:/ {print $2}')
MEM_USED=$(free -m | awk '/Mem:/ {print $3}')
MEM_FREE=$(free -m | awk '/Mem:/ {print $4}')
MEM_PERCENT=$(free | awk '/Mem:/ {printf("%.2f%%", $3/$2 * 100)}')

echo "Total Memory     : ${MEM_TOTAL} MB"
echo "Used Memory      : ${MEM_USED} MB"
echo "Free Memory      : ${MEM_FREE} MB"
echo "Memory Usage     : ${MEM_PERCENT}"
echo

# ---------- Disk Usage ----------
echo "🗄️  Disk Usage:"
DISK_INFO=$(df -h --total | grep 'total')
DISK_USED=$(echo "$DISK_INFO" | awk '{print $3}')
DISK_AVAIL=$(echo "$DISK_INFO" | awk '{print $4}')
DISK_PERCENT=$(echo "$DISK_INFO" | awk '{print $5}')

echo "Total Disk Used  : $DISK_USED"
echo "Disk Available   : $DISK_AVAIL"
echo "Disk Usage       : $DISK_PERCENT"
echo

# ---------- Top Processes ----------
echo "🔥 Top 5 Processes by CPU Usage:"
ps -eo pid,comm,%cpu,%mem --sort=-%cpu | head -n 6
echo

echo "💡 Top 5 Processes by Memory Usage:"
ps -eo pid,comm,%cpu,%mem --sort=-%mem | head -n 6
echo

# ---------- Failed Login Attempts ----------
echo "🔐 Failed Login Attempts:"
if command -v journalctl &> /dev/null; then
    journalctl _COMM=sshd | grep "Failed password" | tail -n 5
elif [ -f /var/log/auth.log ]; then
    grep "Failed password" /var/log/auth.log | tail -n 5
else
    echo "Log data not available or permission denied."
fi

echo
echo "===== ✅ End of Report ====="
