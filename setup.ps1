Param (
    [Parameter(Mandatory, HelpMessage='Please provide a distribution name')]
    [string]$Name,
    [Parameter(Mandatory, HelpMessage='Please provide a rootfs file')]
    [string]$Rootfs,
    [Parameter()]
    [string]$UserName = 'root',
    [Parameter()]
    [switch]$EnableSystemd = $false,
    [Parameter()]
    [switch]$IsAlpine = $false
)

if(!(Test-Path -PathType Container C:\sw\WSL2))
{
    New-Item -ItemType Directory -Path C:\sw\WSL2
}

# OS setup
wsl.exe --import $Name C:\sw\WSL2\$Name $Rootfs
wsl.exe --distribution $Name ./setup.sh
if ( $EnableSystemd -And !($IsAlpine))
{
    wsl.exe --user root --distribution $Name printf '[boot]\\nsystemd=true\\n' `>`> /etc/wsl.conf
}
wsl.exe --shutdown
wsl.exe --user root --distribution $Name printf 'nameserver 1.1.1.1\\nnameserver 1.0.0.1\\n' `> /etc/resolv.conf

# User setup
if ($UserName -ne 'root')
{
    if ($IsAlpine)
    {
        wsl.exe --user root --distribution $Name adduser --disabled-password $UserName
    }
    else
    {
        wsl.exe --user root --distribution $Name useradd --create-home --shell /bin/bash $UserName
    }
    wsl.exe --user root --distribution $Name printf "[user]\\ndefault=$UserName\\n" `>`> /etc/wsl.conf
    wsl.exe --user root --distribution $Name sed -i "/^root/a\$UserName ALL=(ALL) NOPASSWD: ALL" /etc/sudoers
}
wsl.exe --distribution $Name --user $UserName ./user.sh

# Reduce space consumption
wsl.exe --distribution $Name --user root fstrim /
wsl.exe --shutdown
wsl.exe --export $Name C:\sw\WSL2\$Name\$Name.tar
wsl.exe --unregister $Name
wsl.exe --import $Name C:\sw\WSL2\$Name C:\sw\WSL2\$Name\$Name.tar
Remove-Item C:\sw\WSL2\$Name\$Name.tar
exit
