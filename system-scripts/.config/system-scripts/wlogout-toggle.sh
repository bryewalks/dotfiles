#!/bin/bash

if pgrep -x "wlogout" > /dev/null; then
    pkill wlogout
else
    wlogout &
fi
