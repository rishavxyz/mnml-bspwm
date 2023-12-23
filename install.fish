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
    chmod +x ~/.local/bin

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

    set -l programs bspwm polybar dunst sxhkd feh xdg-desktop-portal xdg-desktop-portal-gtk polkit-gnome brightnessctl pamixer gnome-screenshot gnome-keyring xsetroot wmctrl

    switch $pmgr
        case c C Cancel cancel '*'
            say -e exiting program
            say necesarry programs are written in $HOME/programs.txt file, manually install them
            echo "$programs" >~/programs.txt
            return 1

        case a A apt Apt
            say sudo apt install ...
            sudo apt install $programs

        case p P pacman Pacman
            say sudo pacman -S ...
            sudo pacman -S $programs
    end
end

say insatlling programs
install_progs
and say programs installed

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

test -f ~/.fehbg || feh ./bg.png

say installation complete, you are good to go
