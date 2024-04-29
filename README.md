# WSL 2 Labs
> [!WARNING] 
> 1. `user.sh` has `rm -rf ` in it. If it runs amok, all your drives C:\ D:\ E:\ 
> ... will be wiped. Yes, it will totally nuke your Windows
> Host (speaking from experience). You have been warned. If unsure, remove lines 3...6 from `.\user.sh`.
> 2. Ubuntu 24.04 is slow to setup and freezes my entire computer... but it eventually works™.
> 3. Tested this script for `WSL version: 2.0.14.0` running `Windows 11 23H2` on `x86_64` platform using the following:
>       * PowerShell version 7.4.2 on Windows Host
>       * Ubuntu 22.04 and 24.04
>       * Alpine Linux 3.19
>       * RockyLinux 9.3

# Purpose of this project
Spin as many Linux WSL2 instances as I want without any of the junk most distros
have. Said junk may or may not be mission critical. Please don't run it
blindly!!

I also want to override a lot of the defaults that Microsoft and Distro
maintainers have, but instead of manually editing `wsl.conf` everytime I
setup a new instance, I automated everything in these scripts. This gives me the
freedom to experiment more freely within my WSL2 environment without the fear of
losing time if I have to start over again. 

As the name suggests, this is `WSL2 Labs` we can break things here, not in production ;)

I also wanted to dip into PowerShell Scripting and Windows Automation, so if you
see a better way of doing something that I am trying to accomplish, please let
me know either by raising a PR, starting an issue or just writing me an email.

# How to use these scripts?
1. Clone this repo
2. Download the rootfs of the operating system you want, or if you cannot find
   the rootfs you docker export.
3. Create a `rootfs/` directory at the root of this repo and put the compressed
   rootfs in there.
4. Review (or rewrite) `setup.sh` and `user.sh` to fit your needs. These are
   simple POSIX shell scripts and very easy to modify to do your bidding. It has
   some hard coded values like my GitHub username and Windows username hardcoded
   in it.
4. Run `.\setup.ps1` with flags as described below:

    `.\setup.ps1 -Name NAME_FOR_YOUR_DISTRO -Rootfs PATH_TO_ROOTFS -UserName USER_NAME -EnableSystemd $false -IsAlpine $true`

    A. If `-Rootfs` is the path to the compressed rootfs of the distro you want to
    install. If you don't have a compressed rootfs here is where you can get it:
        * Link for [RockyLinux 8 and
        9](https://docs.rockylinux.org/guides/interoperability/import_rocky_to_wsl/).
        Here, it is better to use the Base image rather than the Minimal Image.
        * Link for [Ubuntu 20.04, 22.04 and
        24.04](https://cloud-images.ubuntu.com/wsl/)
        * Link for [Alpine Rootfs](https://alpinelinux.org/downloads/). You would
        want the "Mini Root Filesystem" labeled "x86_64"

    B. Set `-Name` to whatever you want to call that particular WSL2 instance. Could
    be a project name or whatever.

    C. Supply `-UserName` which will be your primary Unix user within this WSL2
    instance. If this option is left out, you will drop in directly as root user.
    If you supply a username, it will automatically become a sudo user without
    any password. The user can change this later in the settings.  

    D. `-IsAlpine` is just a special case check for Alpine Linux since it doesn't
    support `useradd` command and also doesn't support systemd (kinda). Default
    is false. Set `-IsAlpine = $true` if you are using it.

    E. `-EnableSystemd = $false` flag disables systemd and you only use WSL2's init
    and that's it. The default is `$true` which starts systemd and dependant
    services.

5. If you cannot find rootfs for your distro (I am looking at you Fedora!) then please try using [this `docker export` method](https://learn.microsoft.com/en-us/windows/wsl/use-custom-distro).
