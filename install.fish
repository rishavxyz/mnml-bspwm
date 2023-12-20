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

function locally_install -a program_name
    say $program_name
    cd ./$program_name
    sudo make clean install

    if test $status = 0
        say $program_name is installed
        cd ..
    else
        say -e $program_name install failed
        cd ..
        return 1
    end
end

# locally install suckless tools in /usr/local/bin
locally_install dmenu
locally_install slock
locally_install st

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
            sudo apt $programs

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
cp -r ./bspwm ~/.config/
cp -r ./dunst ~/.config/
cp -r ./polybar ~/.config/
cp -r ./sxhkd ~/.config/

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
