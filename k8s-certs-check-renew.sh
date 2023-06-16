#!/bin/bash

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
    echo "Certificates are expiring soon. Renewing..."
    kubeadm alpha cert renew all --config kubeadm-config.yaml
    echo "Certificates renewed. Rebooting the node..."
    reboot
else
    echo "Certificates are valid. No action required."
fi
