#!/bin/bash

# Wait for 10 minutes (600 seconds)
duration=600

# Start the timer
start_time=$(date +%s)

# Display the start time
echo "Start time: $(date)"

# Loop to show the current time
while true; do
  current_time=$(date +%s)
  elapsed_time=$((current_time - start_time))

  if [ $elapsed_time -ge $duration ]; then
    echo "Time's up!"
    break
  fi

  echo -ne "Current time: $(date)\r"
  sleep 1
done
