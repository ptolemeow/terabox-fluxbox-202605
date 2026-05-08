#!/bin/bash
export USER=root
export HOME=/root
export DISPLAY=:1

rm -f "/$HOME/.vnc/*.log" "/$HOME/.vnc/*.pid"
rm -f /tmp/.X[0-9]*-lock
rm -f /tmp/.X11-unix/X[0-9]*
rm -rf /tmp/.org.chromium.Chromium.*

xrdb -merge "$HOME/.Xresources"
xsetroot -solid \#262526
xset r rate 200 30
autocutsel -fork

/usr/bin/x11vnc -display :1 -rfbauth "/$HOME/.vnc/passwd" -forever -shared -repeat -rfbport 5901
