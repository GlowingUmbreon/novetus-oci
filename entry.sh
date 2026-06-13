#!/bin/bash

# Start sway
export XDG_RUNTIME_DIR=/run/user/1000
export XDG_CONFIG_HOME=/home/novetus/.config
export WLR_BACKENDS=headless
export WLR_LIBINPUT_NO_DEVICES=1
sway &
export WAYLAND_DISPLAY=wayland-1

# Start dependencies
wayvnc &
wineserver -p

#Start Novetus
SDL_AUDIODRIVER=dummy WINEDEBUG=-all wine ~/novetus/bin/Novetus.exe \
        -load server \
        -cmdonly \
        -headless \
        -no3d \
        -client "$NOVETUS_CLIENT" \
        -map "Z:\\\\opt\\\\place.rbxl" \
        -hostport $NOVETUS_PORT \
        -maxplayers $NOVETUS_PLAYERS \
        -serverbrowsername "$NOVETUS_NAME" \
        -serverbrowseraddress "$NOVETUS_MASTERSERVER"
