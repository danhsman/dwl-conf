#!/bin/bash

while true; do
    VOL_INFO=$(wpctl get-volume @DEFAULT_AUDIO_SINK@)
    if echo "$VOL_INFO" | grep -q "\[MUTED\]"; then
        VOL_STR="[MUTED]"
    else
        VOL_NUM=$(echo "$VOL_INFO" | awk '{printf "%.0f", $2 * 100}')
        VOL_STR="[VOL: ${VOL_NUM}%]"
    fi

    if playerctl -p spotify status >/dev/null 2>&1; then
        PLAYER_STATUS=$(playerctl -p spotify status)

        if [ "$PLAYER_STATUS" = "Playing" ]; then
            ARTIST=$(playerctl -p spotify metadata --format "{{ artist }}" | xargs)
            TITLE=$(playerctl -p spotify metadata --format "{{ title }}" | sed -E -e 's/ \((with|feat\.?)[^)]*\)//i' -e 's/ *\[v[0-9]+\]//i' | xargs)

            case "$ARTIST" in
                "Lil Uzi Vert")     ARTIST="LUV" ;;
                "Destroy Lonely")   ARTIST="DL" ;;
                "Playboi Carti")    ARTIST="Carti" ;;
                "Ken Carson")       ARTIST="Ken" ;;
                "Nine Vicious")       ARTIST="Nine" ;;
            esac

            SONG_INFO="${ARTIST} - ${TITLE}"
            SONG_STR="[$(echo "$SONG_INFO" | cut -c1-40)] "
        else
            SONG_STR=""
        fi
    else
        SONG_STR=""
    fi

    echo "${SONG_STR}${VOL_STR} $(date +"[%d-%b-%Y] [%I:%M %p]")"
    sleep 1
done
