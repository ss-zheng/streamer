#!/bin/bash

if ! [ -x "$(command -v ffmpeg)" ]; then
  echo 'Installing ffmpeg' >&2
  sudo apt install ffmpeg
fi

source dotenv.sh

# -loglevel warning
# http://trac.ffmpeg.org/wiki/Creating%20multiple%20outputs
while true
do
	for video in $(ls ${video_folder}/*.mp4)
    do
        ffmpeg -re -i "$video" -i "${watermark}" \
            -filter_complex "[0:v]overlay=W-w-5:5,split=2[out1][out2];[0:a]asplit=2[aout1][aout2]" \
            -map '[out1]' -map '[aout1]' -c:v libx264 -preset ultrafast -b:v 4500k -c:a aac -b:a 192k -ar 44100 -strict -2 -f flv ${twitch_rtmp} \
            -map '[out2]' -map '[aout2]' -c:v libx264 -preset ultrafast -b:v 4500k -c:a aac -b:a 128k -strict -2 -f flv ${fb_rtmp}
    done
done
