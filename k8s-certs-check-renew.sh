#!/bin/bash

LOG_FILE="/path/to/log/file.log"

# Function to log messages
log() {
    echo "$(date +'%Y-%m-%d %H:%M:%S') $1" >> "$LOG_FILE"
}

# Check certificate expiration time
expiration=$(kubeadm alpha certs check-expiration | awk '/CERTIFICATE/ {print $2}')

# Convert expiration time to seconds
expiration_seconds=$(date -d "$expiration" +%s)

# Calculate the current time
current_time=$(date +%s)

# Calculate the threshold time (7 days in seconds)
threshold=$((7 * 24 * 60 * 60))

# Compare expiration time with the threshold
if ((expiration_seconds - current_time < threshold)); then
    log "Certificates are expiring soon. Renewing..."

    # Renew certificates and log any errors
    if kubeadm alpha cert renew all --config kubeadm-config.yaml >> "$LOG_FILE" 2>&1; then
        log "Certificates renewed successfully. Rebooting the node..."
        reboot
    else
        log "Error: Certificate renewal failed. Please check the logs for details."
    fi
else
    log "Certificates are valid. No action required."
fi
