#!/usr/bin/bash

sel=$(echo -e "Lock\nLogout\nPoweroff" | dmenu)

case "$sel" in
Lock) slock ;;
Logout) bspc quit ;;
Poweroff) systemctl poweroff ;;
esac
