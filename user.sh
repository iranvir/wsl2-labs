#!/bin/sh
set -e
if [ -n "${HOME}" ] ; then
    cd "${HOME}"
    rm -fr -- ..?* .[!.]* *
fi

cat << EOF > "${HOME}"/.gitconfig
[init]
    defaultBranch = main
[user]
    name = Ranvir Singh
    email = ranvir@numbersandreality.com
EOF

cat << EOF > "${HOME}"/.vimrc
syntax on
set viminfofile=NONE
EOF

cat << EOF > "${HOME}"/.profile
env=~/.ssh/agent.env

agent_load_env () { test -f "$env" && . "$env" >| /dev/null ; }

agent_start () {
    (umask 077; ssh-agent >| "$env")
    . "$env" >| /dev/null ; }

agent_load_env

# agent_run_state: 0=agent running w/ key; 1=agent w/o key; 2=agent not running
agent_run_state=$(ssh-add -l >| /dev/null 2>&1; echo $?)

if [ ! "$SSH_AUTH_SOCK" ] || [ $agent_run_state = 2 ]; then
    agent_start
    ssh-add
elif [ "$SSH_AUTH_SOCK" ] && [ $agent_run_state = 1 ]; then
    ssh-add
fi

unset env

alias ls="ls --color=always"
alias ll="ls -a --color=always"
export PS1="\[\e[36;40m\]\h\[\e[m\]:\[\e[35;40m\]\w\[\e[m\] $ "
EOF
chmod 600 "${HOME}"/.vimrc "${HOME}"/.profile "${HOME}"/.gitconfig

cp -r /mnt/c/Users/ranvir/.ssh "${HOME}"/.ssh
cat << EOF > "${HOME}"/.ssh/config
Host node
    User root
    Hostname 104.225.223.86

Host *
    User root
    HashKnownHosts no
    StrictHostKeyChecking no
    IdentityFile ~/.ssh/id_ed25519
    HostKeyAlgorithms ssh-ed25519
    UserKnownHostsFile ~/.ssh/known_hosts
EOF
chmod 700 "${HOME}"/.ssh
chmod 400 "${HOME}"/.ssh/id_ed25519 "${HOME}"/.ssh/id_ed25519.pub
chmod 600 "${HOME}"/.ssh/config
rm -f "${HOME}"/.ssh/known_hosts*

exit 0
