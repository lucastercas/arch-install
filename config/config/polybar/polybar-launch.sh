#!/bin/sh

killall -q polybar
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

#if type "xrandr"; then
#  for monitor in $(xrandr --query | grep " connected" | cut -d" " -f1); do
#    MONITOR=$monitor polybar --reload top &
#  done
#else
#  polybar --reload top &
#fi
for m in $(polybar --list-monitors | cut -d":" -f1); do
    MONITOR=$m polybar --reload top &
done


#polybar top &
#polybar top-dvi &

notify-send "Polybar Started"
