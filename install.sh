#!/bin/bash
#  install.sh - installs files to setup a systemd USB automount system
#    on a Debian based system. Works for me, may not for you.
#
#  TODO - Reduce required assumptions

DEBIAN_SYSTEMD=/lib/systemd/systemd
DEBIAN_UDISKS2=/usr/libexec/udisks2/udisksd
DEBIAN_POLKIT=/usr/libexec/polkitd
ARCH_SYSTEMD=/usr/lib/systemd/systemd
ARCH_UDISKS2=/usr/lib/udisks2/udisksd
ARCH_POLKIT=/usr/lib/polkit-1/polkitd
INSTALL=/usr/bin/install
MKDIR=/bin/mkdir
SYSTEMCTL=/bin/systemctl

_die() {
    echo >&2 "${*}"
    exit 1
}

# Are we root
if [ `id -u` -ne 0 ]; then
    _die "Need to be root"
fi

# Check for systemd
for daemon in "$DEBIAN_SYSTEMD $ARCH_SYSTEMD"
do
    if [ ! -x $daemon ]
    then
      _die "$SYSTEMD missing, is systemd installed?"
    fi
done

# Check for udisks2
for daemon in "$DEBIAN_UDISKS2 $ARCH_UDISKS2"
do
    if [ ! -x $daemon ]
    then
        _die echo "$daemon missing, is udisks2 installed?"
    fi
done

# Check for polkit
for daemon in "$DEBIAN_POLKIT $ARCH_POLKIT"
do
    if [ ! -x $daemon ]
    then
      _die "$daemon missing, is polkit installed?"
    fi
done

# Udev should be installed, check anyway
if [ ! -d /etc/udev/rules.d ]
then
    _die "/etc/udev/rules.d missing, is udev installed?"
fi

# Check for files to be installed
for file in 99-local.rules 10-udisks2.rules usb-mount@.service remusb
do
    if [ ! -f $file ]
    then
        _die "Missing $file"
    fi
done

# Create directories if necessary
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

# Install files
$INSTALL -b -m 644 99-local.rules /etc/udev/rules.d
$INSTALL -b -m 644 10-udisks2.rules /etc/polkit-1/rules.d
$INSTALL -b -m 644 -g $SUDO_USER -o $SUDO_USER usb-mount@.service /home/$SUDO_USER/.config/systemd/user
$INSTALL -b -m 744 -g $SUDO_USER -o $SUDO_USER remusb /home/$SUDO_USER/.local/bin

echo "Installaton complete, reboot the system"
