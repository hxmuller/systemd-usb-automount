# systemd-usb-automount
A simple usb automount setup for Debian installations. When USB flash storage is inserted into an open port, it is automatically mounted on /media/$USER/\<LABEL\>.

Requirements:
- systemd
- udisks2
- policykit-1

Most standard Debian installs will include systemd, udisks2 and policykit-1 will need to be installed:

```
$ sudo apt install udisks2 policykit-1
```

To install, after download run:

```
$ chmod +x install.sh
$ sudo ./install.sh
```
To unmount and power off the USB flash storage, run the included executable script:

```
$ remusb
```
