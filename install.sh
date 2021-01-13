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
LSB_RELEASE=/usr/bin/lsb_release
GREP=/bin/grep
AWK=/usr/bin/awk
DISTRIBUTION=$( lsb_release -a 2>/dev/null | grep Description | awk '{print $2}' )

_die() {
    echo >&2 "${*}"
    exit 1
}

# Are we root
if [ `id -u` -ne 0 ]; then
    _die "Need to be root"
fi

case $DISTRIBUTION in
    Debian|Ubuntu)
        SYSTEMD=$DEBIAN_SYSTEMD
        UDISKS2=$DEBIAN_UDISKS2
        POLKIT=$DEBIAN_POLKIT
        ;;
    Arch|Manjaro)
        SYSTEMD=$ARCH_SYSTEMD
        UDISKS2=$ARCH_UDISKS2
        POLKIT=$ARCH_POLKIT
    *)
        _die "Must manually add distribution to case statement"
esac

# Check for systemd
if [ ! -e "$SYSTEMD" ]
then
  _die "${dist}_SYSTEMD missing, is systemd installed?"
fi

# Check for udisks2
if [ ! -e "$UDISKS2" ]
then
    _die echo "${dist}_UDISKS2 missing, is udisks2 installed?"
fi

# Check for polkit
if [ ! -e "$POLKIT" ]
then
  _die "${dist}_POLKIT missing, is polkit installed?"
fi

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
