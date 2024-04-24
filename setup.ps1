Param (
    [Parameter(Mandatory, HelpMessage='Please provide a distribution name')]
    [string]$Name,
    [Parameter(Mandatory, HelpMessage='Please provide a rootfs file')]
    [string]$Rootfs,
    [Parameter()]
    [string]$UserName = 'root',
    [Parameter()]
    [bool]$EnableSystemd = $true
)

# OS setup
wsl.exe --import $Name C:\$Name $Rootfs
wsl.exe --distribution $Name ./setup.sh
if (($UserName -ne 'root') -And !($IsAlpine))
{
    wsl.exe --user root --distribution $Name printf "[boot]\\nsystemd=true\\n" `>`> /etc/wsl.conf
}
wsl.exe --shutdown
wsl.exe --user root --distribution $Name printf 'nameserver 1.1.1.1\nnameserver 1.0.0.1\n' `> /etc/resolv.conf

# User setup
if ($UserName -ne 'root')
{
    if ($EnableSystemd)
    {
        wsl.exe --user root --distribution $Name useradd $UserName --create-home --shell /bin/bash
        wsl.exe --user root --distribution $Name passwd -l $UserName
    }
    else
    {
        wsl.exe --user root --distribution $Name adduser --disabled-password $UserName
    }
    wsl.exe --user root --distribution $Name printf "[user]\\ndefault=$UserName\\n" `>`> /etc/wsl.conf
    wsl.exe --user root --distribution $Name sed -i "/^root/a\$UserName ALL=(ALL) NOPASSWD: ALL" /etc/sudoers
}
wsl.exe --shutdown
wsl.exe --distribution $Name --user $UserName ./user.sh

# Reduce space consumption
wsl.exe --distribution $Name --user root fstrim /
wsl.exe --shutdown
wsl.exe --export $Name C:\$Name\$Name.tar
wsl.exe --unregister $Name
wsl.exe --import $Name C:\$Name C:\$Name\$Name.tar
Remove-Item C:\$Name\$Name.tar
exit
