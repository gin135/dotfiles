#!/bin/sh

host=$(hostname)


##############################
# Input
##############################

# Xmodmap
[ -f $HOME/.Xmodmap ] && xmodmap $HOME/.Xmodmap

# Mouse_Speed
xset m 0 0

# Key_Repeat
xset r rate 300 40

# Imput_Method
export XMODIFIERS=@im='uim'
export GTK_IM_MODULE='uim'
export QT_IM_MODULE='uim'
uim-xim &
#uim-toolbar-gtk-systray &



##############################
# Display
##############################

# Display
[ $host = "albicilla" ] && xrandr --output DVI-0 --auto --left-of HDMI-0
[ $host = "neofelis" ] && xrandr --output DVI-0 --auto --left-of HDMI-0
[ $host = "uralensis" ] && xrandr --output HDMI-2 --left-of HDMI-1 --auto


# Screensaver
xset s off #[timeout cycle]
# Energy_Star
xset -dpms
# Beep
xset b off


# XScreenSaver
[ $host = "uncia" ] && /usr/bin/xscreensaver -no-splash &


# Wallpaper(random_change)
while true; do
    find ~/Dropbox/wallpaper_faves -type f \( -name '*.jpg' -o -name '*.png' \) -print0 | shuf -n1 -z | xargs -0 feh --bg-fill
    sleep 300s
done &



##############################
# Etc
##############################

# Synergy_server
[ $host = "concolor" ] && synergys &

# Dropbox
killall dropbox
dropbox-cli start &



#----------------------------------------------------------------------------

##############################
# for dwm_status_bar
##############################

sep=" | "
ip_addr=""

while true; do

    cpu_used="$(awk '{print $1,$2,$3}' /proc/loadavg )"
    cpu_governer="$(cut -c1-3 /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor)"
    [ $(echo $cpu_governer | wc -w) -ne 0 ] && cpu_governer=" ($cpu_governer)"
    max_mem=`grep -E "(^MemTotal:)" /proc/meminfo | awk '{FS=" "}{printf("%d", ($2)/1024)}'`
    free_mem=`grep -E "(^MemTotal:|^MemAvailable:)" /proc/meminfo | awk '{FS=" "}{print $2}' | tr '\n' ' ' | awk '{FS=" "}{printf("%d", ($1-$2)/1024)}'`
    mem_used="$free_mem/$max_mem MB"

    for network_if in "$(ip addr |grep '^[1-9]:' |cut -d' ' -f2 |tr -d ':' |grep -v '^lo$' |xargs)"; do
        ip_addr=`LANG=C /sbin/ip addr show ${network_if} 2> /dev/null | grep 'inet ' | awk '{print $2}'`
        if [ ${#ip_addr} -ne 0 ]; then
            break
        fi
    done
    if [ ${#ip_addr} -eq 0 ]; then
        network_if="NC"
    else
        network_if="${network_if}:"
    fi


    if [ $(LANG=c acpi -b | wc -w) -ne 0 ]; then
        batt="$(LANG=c acpi -b)"
        batt="${batt#*, }"
        batt="${batt%,*}"

        case `acpi -b` in
            *Discharging*)
                batt="!$batt!"
                ;;
            *Charging*)
                batt="+$batt+"
                ;;
            *)
                batt="$batt"
                ;;
        esac
        batt="$sep$batt$sep"
    else
        batt="$sep"
    fi


    date_full="$(LANG=c date +%m/%d\(%a\)\ %H:%M)"

    xsetroot -name "$cpu_used$cpu_governer$sep$mem_used$sep$network_if$ip_addr$batt$date_full"

    sleep 2
done &



##############################
# exec Display_Manager
##############################

exec dwm 2> ~/.dwm.log
#exec icewm

#while true; do
#    ## Log stderror to a file
#    dwm 2> ~/.dwm.log
#    ## No error logging
#    #dwm >/dev/null 2>&1
#done
