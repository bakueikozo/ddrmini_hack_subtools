#!/bin/sh


CURPATH=`dirname $0`

# confirm cd to this current directory
/opt/swupdate-progress/swupdate-progress --msg-only --txt "$CURPATH" --hoff 0 --bg /usr/local/res/swu_bg_blank.png
sleep 5
/sbin/insmod $CURPATH/modules/libcomposite.ko
/sbin/insmod $CURPATH/modules/roles.ko
/sbin/insmod $CURPATH/modules/u_serial.ko
/sbin/insmod $CURPATH/modules/usb_f_serial.ko
/sbin/insmod $CURPATH/modules/usb_f_obex.ko
/sbin/insmod $CURPATH/modules/usb_f_acm.ko
/sbin/insmod $CURPATH/modules/g_serial.ko use_acm=1

cat /sys/devices/virtual/tty/ttyGS0/dev

DEV=`cat /sys/devices/virtual/tty/ttyGS0/dev`
/opt/swupdate-progress/swupdate-progress --msg-only --txt "$DEV" --hoff 0 --bg /usr/local/res/swu_bg_blank.png

#confirm displayed 237:0
mknod /dev/ttyGS0 c 237 0

# powered busybox!
cp $CURPATH/busybox /tmp
chmod 755 /tmp/busybox

#overwrite passwd empty
mount -o rw,remount /
cp $CURPATH/passwd /etc/passwd

cp $CURPATH/shell.sh /tmp
chmod 755 /tmp/shell.sh
/tmp/shell.sh &

dmesg >> $CURPATH/dmesg.log
sync
sync
sync

/opt/swupdate-progress/swupdate-progress --msg-only --txt "Script Finished!!!" --hoff 0 --bg /usr/local/res/swu_bg_blank.png
