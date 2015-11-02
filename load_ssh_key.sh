#!/usr/bin/env bash
# http://tammersaleh.com/posts/building-an-encrypted-usb-drive-for-your-ssh-keys-in-os-x/
HOURS=$1
DIR=/media/Loz
KEY=$DIR/id_rsa

if [ -z $HOURS ]; then
    HOURS=2
fi

/usr/bin/ssh-add -D
/usr/bin/ssh-add -t ${HOURS}H $KEY
/usr/sbin/diskutil umount force $DIR
