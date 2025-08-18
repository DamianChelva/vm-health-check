#!/bin/bash

# Threshold for health check
THRESHOLD=75
DETAILS=false

# Check for 'details' parameter (case-insensitive)
if [[ "${1,,}" == "details" ]]; then
    DETAILS=true
fi

# Get Disk usage (root partition, as percentage)
disk_usage=$(df / | awk 'NR==2 {gsub("%","",$5); print $5}')

# Get Memory usage (percentage)
mem_usage=$(free | awk '/Mem:/ {printf("%.0f", $3/$2 * 100)}')

# Get CPU usage (average over 1 second)
cpu_idle=$(top -bn2 -d1 | grep "Cpu(s)" | tail -n1 | awk -F'id,' '{ split($1, vs, ","); v=vs[length(vs)]; sub("%", "", v); print v }')
cpu_usage=$(printf "%.0f" "$(echo "100 - $cpu_idle" | bc)")

state="healthy"
details_msg=""

# Check if any resource is over/equal threshold
if [ "$disk_usage" -ge "$THRESHOLD" ]; then
    state="unhealthy"
    details_msg+="Disk usage is ${disk_usage}% (>=${THRESHOLD}%). "
fi
if [ "$mem_usage" -ge "$THRESHOLD" ]; then
    state="unhealthy"
    details_msg+="Memory usage is ${mem_usage}% (>=${THRESHOLD}%). "
fi
if [ "$cpu_usage" -ge "$THRESHOLD" ]; then
    state="unhealthy"
    details_msg+="CPU usage is ${cpu_usage}% (>=${THRESHOLD}%). "
fi

# ...existing code...
if $DETAILS; then
    echo "State: $state"
    echo "Disk usage: ${disk_usage}%"
    echo "Memory usage: ${mem_usage}%"
    echo "CPU usage: ${cpu_usage}%"
    if [ "$state" == "unhealthy" ]; then
        echo "Reason(s): $details_msg"
    fi
    echo ""
    echo "Disk space usage for root directories (/):"
    sudo du -sh /* 2>/dev/null | sort -hr
else
    echo "$state"
fi
# ...existing code...
#if $DETAILS; then
#   echo "State: $state"
#    echo "Disk usage: ${disk_usage}%"
#    echo "Memory usage: ${mem_usage}%"
#    echo "CPU usage: ${cpu_usage}%"
#    if [ "$state" == "unhealthy" ]; then
#        echo "Reason(s): $details_msg"
#    fi
#else
#    echo "$state"
#fi
