#!/bin/bash



if [ "$1" == "-c" ]; then

    # Cancel a scheduled shutdown

    systemctl poweroff -c

    notify-send "Shutdown cancelled."

else

    # Schedule shutdown for 15 seconds from now

    shutdown -h `date --date "now + 5 seconds"`

    notify-send "System will shut down in 15 seconds."

fi
