#!/bin/bash
#  install.sh - installs files to setup a systemd USB automount system
#    on a Debian based system. Works for me, may not for you.
#
#  TODO - Reduce required assumptions

SYSTEMD=/bin/systemd
INSTALL=/usr/bin/install
MKDIR=/bin/mkdir
UDEVADM=/bin/udevadm
SYSTEMCTL=/bin/systemctl

if [ ! -x $SYSTEMD ]
then
  echo "$SYSTEMD missing, is systemd installed?"
  exit 1
fi
if [ ! -x $INSTALL ]
then
  echo "$INSTALL missing"
  exit 1
fi

for file in 99-local.rules 10-udisks2.rules usb-mount@.service remusb
do
    if [ ! -f $file ]
    then
        echo "Missing $file"
        exit 1
    fi
done

if [ ! -d /etc/udev/rules.d ]
then
    echo "/etc/udev/rules.d missing, is udev installed?"
    exit 1
fi


if [ ! -d /etc/polkit-1 ]
then
    echo "/etc/polkit-1 missing, is policykit-1 installed?"
    exit 1
fi
if [ ! -d /etc/polkit-1/rules.d ]
then
    $MKDIR /etc/polkit-1/rules.d
fi

if [ ! -d /home/$SUDO_USER/.config/systemd/user ]
then
    $MKDIR -p /home/$SUDO_USER/.config/systemd/user
fi

if [ ! -d $HOME/.local/bin ]
then
    $MKDIR -p $HOME/.local/bin
fi

$INSTALL -b -m 644 99-local.rules /etc/udev/rules.d
$INSTALL -b -m 644 10-udisks2.rules /etc/polkit-1/rules.d
$INSTALL -b -m 644 -g $SUDO_USER -o $SUDO_USER usb-mount@.service /home/$SUDO_USER/.config/systemd/user
$INSTALL -b -m 744 -g $SUDO_USER -o $SUDO_USER remusb /home/$SUDO_USER/.local/bin

$SYSTEMCTL reboot
