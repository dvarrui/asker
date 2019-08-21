
[<< back](README.md)

# Using installation scripts

## GNU/Linux installation

> Tested on: OpenSUSE, Debian, Ubuntu.

Run as `root` user:
```
wget -qO- https://raw.githubusercontent.com/dvarrui/asker/master/bin/linux_asker_install.sh | bash
```

Run `asker version` as normal user.


## Windows script

Requirements:
* Windows 7+ / Windows Server 2003+
* PowerShell v2+

Run this coomand as Administrator user on PowerShell (PS):
```
Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/dvarrui/asker/master/bin/windows_asker_install.ps1'))
```

Run `asker version` as normal user.