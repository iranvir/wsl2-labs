#!/bin/sh
set -e
. /etc/os-release

if [ "${ID}" = 'alpine' ] ; then
    sed -i 's/v[0-9]*\.[0-9]*/edge/g' /etc/apk/repositories
    sed -i '$ahttps://dl-cdn.alpinelinux.org/alpine/edge/testing' /etc/apk/repositories
    apk -U upgrade
    apk add sudo
fi

if [ "${ID}" = 'rocky' ] ; then
    dnf update --assumeyes --quiet
    dnf install coreutils systemd ncurses procps-ng openssh-clients vim sudo which --allowerasing --assumeyes --quiet
    dnf clean all --assumeyes --quiet
fi

if [ "${ID}" = 'ubuntu' ] ; then
    apt update --quiet --yes
    apt upgrade --quiet --yes
    apt purge show-motd update-motd snapd openssh-client openssh-server cloud-init git python3 --quiet --yes
    apt autoremove --purge --quiet --yes
fi

cat << EOF > /etc/wsl.conf
[interop]
enabled=false
appendWindowsPath=false
[network]
generateResolvConf=false
hostname=${WSL_DISTRO_NAME}
[automount]
enabled=true
mountFsTab=false
EOF

rm -rf /etc/cloud /var/lib/cloud /etc/profile* /etc/bash* /etc/skel /etc/rc*     /etc/sudoers.d /etc/python* /etc/update-motd*

exit 0
