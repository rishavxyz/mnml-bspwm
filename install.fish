#!/usr/bin/fish

function say
    argparse c/color= e/error -- $argv
    or return

    if test $_flag_e
        set clr red
    else if test $_flag_c
        set clr $_flag_c
    else
        set clr green
    end

    set_color $clr
    echo "$argv"
    set_color normal
end

function install_suckless
    mkdir -p ~/.local/bin
    and chmod +x ~/.local/bin
    cp -vr ./suckless/* ~/.local/bin/
end

install_suckless
and say "dmenu, st and slock are installed in $HOME/.local/bin"
or say -e "Could not install some dmenu, st and slock"

# locally install fonts
say installing fonts...

test -d ~/.local/share/fonts || mkdir ~/.local/share/fonts
and cp ./fonts/* -r ~/.local/share/fonts/
and fc-cache -f

say fonts are installed

# ask the user to install the rest program manually
function install_progs
    read -P 'OS package manager? [a]pt, [p]acman, [c]ancel > ' pmgr

    set -l programs bspwm polybar dunst sxhkd feh xdg-desktop-portal xdg-desktop-portal-gtk brightnessctl pamixer gnome-screenshot gnome-keyring wmctrl
    set -l arch_cmd "sudo pacman -S --needed $programs xorg-server xsetroot polkit-gnome"
    set -l deb_cmd "sudo apt install $programs xorg x11-xserver-utils policykit-1-gnome"

    switch $pmgr
        case a A apt Apt
            say sudo apt install ...
            eval $deb_cmd

        case p P pacman Pacman
            set -l cmd "sudo pacman -S --needed $programs xorg-server xsetroot polkit-gnome"
            say sudo pacman -S ...
            eval $arch_cmd

        case c C Cancel cancel '*'
            say -e installation abort
            say -c normal programs are written in \"$HOME/programs.txt\" file
            say -c normal either manually install them
            say -c brblue or use \"install_mnml_bspwm_arch\" alias for Arch Linux
            say -c brblue or use \"install_mnml_bspwm_deb\" alias for Debian Linux
            echo "$programs" >~/programs.txt

            alias install_mnml_bspwm_arch="eval $arch_cmd"
            alias install_mnml_bspwm_deb="eval $deb_cmd"
            return 1
    end
    if test $status -eq 0
        say installation complete
    end
end

say insatlling programs...
echo
install_progs

# now copy the configs
say copying config files
cp -vr ./bspwm ~/.config/
cp -vr ./dunst ~/.config/
cp -vr ./polybar ~/.config/
cp -vr ./sxhkd ~/.config/

if test -f ~/.xinitrc
    say -c orange .xinitrc file exists
    say -c orange renaming .xinitrc to .xinitrc.bak
    mv ~/.xinitrc{,.bak}
end

cp ./xinitrc ~/.xinitrc
and say all config files are copied
or say -e cannot copy .xinitrc

test -f ~/.fehbg
or echo -e "#!/bin/sh\nfeh --no-fehbg --bg-fill $(realpath ./bg.png)" >~/.fehbg

ehco
say installation complete, you are good to go
