#!/bin/sh
set -e
. /etc/os-release

if [ "${ID}" = 'alpine' ] ; then
    sed -i 's/v[0-9]*\.[0-9]*/edge/g' /etc/apk/repositories
    sed -i '$ahttps://dl-cdn.alpinelinux.org/alpine/edge/testing' /etc/apk/repositories
    apk -U --no-cache upgrade
    apk --no-cache add sudo
fi

if [ "${ID}" = 'rocky' ] ; then
    dnf update --assumeyes --quiet
    dnf install coreutils systemd ncurses procps-ng openssh-clients vim sudo which tmux rsync git glibc-langpack-en iputils dnf-plugins-core --allowerasing --assumeyes --quiet
    dnf config-manager --enable crb
    dnf clean all --assumeyes --quiet
fi

if [ "${ID}" = 'fedora' ] ; then
    dnf update --assumeyes --quiet
    dnf install coreutils systemd ncurses procps-ng openssh-clients vim sudo which tmux rsync git glibc-langpack-en iputils --allowerasing --assumeyes --quiet
    dnf install htop hwloc --assumeyes --quiet
    dnf clean all --assumeyes --quiet
    systemctl disable --now systemd-resolved
fi

if [ "${ID}" = 'ubuntu' ] ; then
    apt-get update --quiet --yes
    apt-get upgrade --quiet --yes
    apt-get purge show-motd update-motd snapd openssh-client openssh-server cloud-init git python3 systemd-resolved --quiet --yes
    apt-get autoremove --purge --quiet --yes
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

rm -rf /bin.usr-is-merged /lib.usr-is-merged /sbin.usr-is-merged \
    /etc/resolv.conf /etc/cloud /etc/profile* /etc/bash* /etc/skel /etc/rc* /etc/sudoers.d /etc/python* /etc/update-motd* /etc/ubuntu-advantage \
    /var/lib/cloud /usr/lib/python3/dist-packages /var/lib/command-not-found

exit 0
