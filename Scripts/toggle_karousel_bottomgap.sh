#!/bin/bash

CONFIG="kwinrc"
SECTION="Script-karousel"
KEY="gapsOuterBottom"
ENABLEKEY="karouselEnabled"

# Toggle Logic
ENABLECURRENT=$(kreadconfig6 --file $CONFIG --group Plugins --key $ENABLEKEY)
current=$(kreadconfig6 --file $CONFIG --group $SECTION --key $KEY)

if [ "$ENABLECURRENT" = "true" ]; then
    if [ "$current" -eq 20 ]; then
        new_value=60
    else
        new_value=20
    fi

    kwriteconfig6 --file $CONFIG --group $SECTION --key $KEY $new_value &
    echo "new value: $new_value"

    # Apply changes
    echo "Reloading..."
    kwriteconfig6 --file kwinrc --group Plugins --key "$ENABLEKEY" false &
    qdbus org.kde.KWin /KWin reconfigure &
    sleep 0.3
    wait
    kwriteconfig6 --file kwinrc --group Plugins --key "$ENABLEKEY" true
    qdbus org.kde.KWin /KWin reconfigure

    #kwin_wayland --replace #disown
    #plasmashell --replace

    echo "Karousel Bottom Gap is Toggled."
else
    echo "Karousel is currently disabled. Cannot run command."
fi




