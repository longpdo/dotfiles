#!/bin/bash

# Remove media files when the duration of the file is shorter than _DURATION in seconds
# | Checks every .mkv .mp4 .mp3 file in current folder and subfolders
# | Dependencies: fd, ffmpeg, trash

# Log Helper
_info()    { echo -e "\033[1m[INFO]\033[0m $1" ; }
_warning() { echo -e "\033[33m[WARNING]\033[0m $1" ; }

# Variables
_DURATION=60.0

# Check whether there are any media files to inspect
files=$(fd -e mkv -e mp4 -e mp3 | wc -l)
[[ $files -eq 0 ]] && _warning 'No video files found.' && exit

# Loop over every media file in the current folder and subfolders
fd -0 -e mkv -e mp4 -e mp3 | while IFS= read -d '' -r video; do
  # Get media duration in seconds
  length=$(ffprobe -i "$video" -show_entries format=duration -v quiet -of csv="p=0")

  # If media duration shorter than 45 seconds, move the file to the trash
  (( $(echo "$length < $_DURATION" | bc -l) )) && trash "$video" && _info "Removed - $video"
done
