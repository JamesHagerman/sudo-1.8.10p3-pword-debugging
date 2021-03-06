#!/sbin/sh
#
# Simple HP-UX init.d script to remove the sudo timestamp directory on boot.
# This is needed because HP-UX does not clear /var/run on its own.
# Install as /sbin/init.d/sudo with a link /sbin/rc2.d/S900sudo
#

PATH=/usr/sbin:/usr/bin:/sbin
export PATH

TSDIR="/var/run/sudo/ts"
rval=0

case "$1" in
start_msg)
    echo "Removing the $TSDIR directory"
    ;;
start)
    rm -rf "$TSDIR"
    ;;
*)
    echo "usage: $0 {start|start_msg}"
    rval=1
    ;;
esac

exit $rval
