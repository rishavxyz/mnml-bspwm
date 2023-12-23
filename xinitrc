startOnce() {
	[ pidof "$1" ] || "$@" &
	sleep 0.3s
}

xsetroot -cursor_name left_ptr
dbus-update-activation-environment --all
PATH=$PATH:~/.local/bin

#### autostart applications
startOnce /usr/lib/xdg-desktop-portal
startOnce /usr/lib/xdg-desktop-portal-gtk
startOnce /usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1
startOnce dunst
startOnce ~/.fehbg

exec bspwm
