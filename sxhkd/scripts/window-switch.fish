set -l windows (bspc query -N -n .window)

for window in $windows
    set -l sel_window (xprop -id $window WM_NAME | string split ' = ' | tail -1 | string replace '"' '' -a | dmenu -l 10)

    bspc node $sel_window --focus
    or return 1
end
