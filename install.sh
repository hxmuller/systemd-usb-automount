#!/bin/bash
#  install.sh - installs files to setup a systemd USB automount system
#    on a Debian based system. Works for me, may not for you.
#
#  TODO - Reduce required assumptions

SYSTEMD=/bin/systemd
INSTALL=/usr/bin/install
MKDIR=/bin/mkdir

[ -x $SYSTEMD ] || echo "Missing $SYSTEMD"; exit 1;
[ -x $INSTALL ] || echo "Missing $INSTALL"; exit 1;

for file in 99-local.rules 10-udisks2.rules usb-mount@.service remusb
do
  [ -x $file ] || echo "Missing $file"; exit 1;
done

$INSTALL -b -m 644 99-local.rules /etc/udev/rules.d/
$INSTALL -b -m 644 10-udisks2.rules /etc/polkit-1/rules.d/
$INSTALL -b -m 644 -g $SUDO_USER -o $SUDO_USER usb-mount@.service $HOME/.config/systemd/user/

if [ ! -d $HOME/.local/bin ]
then
  $MKDIR -p $HOME/.local/bin
fi

$INSTALL -b -m 744 -g $SUDO_USER -o $SUDO_USER remusb $HOME/.local/bin/
