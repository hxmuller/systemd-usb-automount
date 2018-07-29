# systemd-usb-automount
A simple usb automount setup for Debian installations. When USB flash storage is inserted into an open port, it is automatically mounted on /media/$USER/\<LABEL\>.

To install, after download run:

```
$ chmod +x install.sh
$ sudo ./install.sh
```
To unmount and power off the USB flash storage, run the included executable script:

```
$ remusb
```
