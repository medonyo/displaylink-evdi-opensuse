# DisplayLink evdi Driver install for openSUSE Tumbleweed #

## Pre-Requisite ##

- DKMS You have to install a valid dkms package (search for the package on [https://software.opensuse.org/package/dkms])
- Bash
- patch
- Linux Kernel Headers
- gcc

## Prepare the installer ##

launch the script
```
./InstallDisplayLink.sh
```

The script will download the Ubuntu driver 1.1.62, and apply the needed patch, so that it works for openSUSE Tumbleweed.

Just after enter in the displaylink-1.1.62 directory and launch the install script:
```
cd build/displaylink-1.1.62
./displaylink-installer.sh install
```

In case of issues start service again:
```
systemctl start displaylink.service
```
and
```
journalctl -xe
```
for debugging.
