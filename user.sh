#!/bin/sh
DOT_FILES_PATH="${PWD}"
set -e
if [ -n "${HOME}" ] ; then
    cd "${HOME}"
    rm -fr -- ..?* .[!.]* *
fi

# Dotfiles setup
cp "${DOT_FILES_PATH}"/dotfiles/profile "${HOME}"/.profile
cp "${DOT_FILES_PATH}"/dotfiles/vimrc "${HOME}"/.vimrc
cp "${DOT_FILES_PATH}"/dotfiles/gitconfig "${HOME}"/.gitconfig
chmod 600 "${HOME}"/.vimrc "${HOME}"/.profile "${HOME}"/.gitconfig 

# SSH Setup
cp -r /mnt/c/Users/ranvir/.ssh "${HOME}"/.ssh
cp "${DOT_FILES_PATH}"/dotfiles/ssh_config "${HOME}"/.ssh/config
chmod 700 "${HOME}"/.ssh
chmod 400 "${HOME}"/.ssh/id_ed25519 "${HOME}"/.ssh/id_ed25519.pub
chmod 600 "${HOME}"/.ssh/config
rm -f "${HOME}"/.ssh/known_hosts*

exit 0
