# systemd-usb-automount
A simple usb automount setup for Debian, Arch, and their derivative
distributions. When USB flash
storage is inserted into an open port, it is automatically mounted in
/media/$USER/\<LABEL\> one of two places depending on distribution:

- /media/$USER/\<LABEL\>
- /run/media/$USER/\<LABEl\>

## Requirements:

- systemd
- udisks2
- polkit

### Arch and derivatives

Arch - check to see if requirements are met and install any if
necessary.

``` $ sudo pacman -S <package name[s]> ```

Manjaro Arm Sway Edition - includes the requirements.

### Debian and derivatives:

Most standard Debian installs will include systemd. udisks2 and
policykit-1 may need to be installed depending on your local
installation. If the install.sh script fails, you may need to install
either or both:

``` $ sudo apt install udisks2 policykit-1 ```

## Installation

To install after checking requirements are met run:

```
$ chmod +x install.sh
$ sudo ./install.sh
```

To unmount and power off the USB flash storage, run the included
executable script:

```
$ remusb
```
