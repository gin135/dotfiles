#!/bin/sh

host=$(hostname)

##############################
# Input
##############################

# Xmodmap
[ -f $HOME/.Xmodmap ] && xmodmap $HOME/.Xmodmap

# Mouse_Speed
## xinputで対応する
# xset m 0 0

# Key_Repeat
xset r rate 300 40

# Imput_Method
export GTK_IM_MODULE='uim'
export QT_IM_MODULE='uim'
uim-xim &
export XMODIFIERS='@im=uim'

# Wacom
if [ ${host} = "uralensis" ]; then
    wacom_id = xsetwacom --list devices | grep stylus | grep -o 'id: [0-9]*' | awk '$0=$2'
    primary_disp = xrandr | grep 'connected primary' | awk '$0=$1'

    xsetwacom --set ${wacom_id} MapToOutput "${primary_disp}"
fi


##############################
# Display
##############################

# Display
[ ${host} = "albicilla" ] && xrandr --output DVI-0 --auto --left-of HDMI-0
[ ${host} = "neofelis" ] && xrandr --output DVI-0 --auto --left-of HDMI-0
[ ${host} = "uralensis" ] && xrandr --output HDMI-2 --left-of HDMI-1 --auto


# Screensaver
xset s off #[timeout cycle]
# Energy_Star
xset -dpms
# Beep
xset b off


# ScreenSaver & ScreenLock
case ${host} in
    "caracal" | "manul" )
        /usr/bin/xscreensaver -no-splash &
        /usr/bin/xss-lock -- /usr/bin/xscreensaver-command --lock >/dev/null &
        break ;;
esac


# Wallpaper(random_change)
case ${host} in
    "caracal" | "manul" )
        wallpaper="wallpaper_animal"
        ;;
    *)
        wallpaper="wallpaper_faves"
        ;;
esac

while true; do
    find ~/Dropbox/${wallpaper} -type f | grep -iE '[.](jpg|png)$' | shuf | head -n 1 | xargs feh --bg-fill
    sleep 300s
done &



##############################
# Etc
##############################

# Dropbox
killall dropbox
dropbox-cli start &



#----------------------------------------------------------------------------

##############################
# for dwm_status_bar
##############################

sep=" | "
while true; do
    cpu_used=$(awk '{print $1,$2,$3}' /proc/loadavg )
    cpu_governer=$(cut -c1-3 /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor)

    max_mem=$(grep -E "(^MemTotal:)" /proc/meminfo | awk '{FS=" "}{printf("%d", ($2)/1024)}')
    free_mem=$(grep -E "(^MemTotal:|^MemAvailable:)" /proc/meminfo | awk '{FS=" "}{print $2}' | tr '\n' ' ' | awk '{FS=" "}{printf("%d", ($1-$2)/1024)}')
    mem_used="${free_mem}/${max_mem} MB"

    ip=$(ip addr | grep 'inet ' | grep -vE '$(lo|docker[[:digit:]]*)$' | head -n 1 | awk '{print $NF":"$2}'
    [ -z ${ip} ] && ip="NC"

    if [ -n "$(acpi -b)" ]; then
        batt=$(acpi -b | grep -o '[0-9]*%')

        case $(acpi -b) in
            *Discharging*)
                batt="!${batt}!"
                ;;
            *Charging*)
                batt="+${batt}+"
                ;;
            *)
                batt="${batt}"
                ;;
        esac
        batt=${sep}${batt}${sep}
    else
        batt=${sep}
    fi


    date_full=$(LANG=C date +%m/%d\(%a\)\ %H:%M)

    xsetroot -name "${cpu_used} (${cpu_governer})${sep}${mem_used}${sep}${ip}${batt}${date_full}"

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
