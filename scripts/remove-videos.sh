#!/bin/bash

# Remove videos, if the video length is shorter than _VIDEO_LENGTH in seconds
# | Checks every video in current folder and subfolders
# | Dependencies: fd, ffmpeg, trash

# Log Helper
_info()    { echo -e "\033[1m[INFO]\033[0m $1" ; }
_warning() { echo -e "\033[33m[WARNING]\033[0m $1" ; }

# Variables
_VIDEO_LENGTH=25.0

# Check whether there are any video files to inspect
files=$(fd -e mkv -e mp4 | wc -l)
[[ $files -eq 0 ]] && _warning 'No video files found.' && exit

# Loop over every video file in the current folder and subfolders
fd -0 -e mkv -e mp4 | while IFS= read -d '' -r video; do
  # Get video length in seconds
  length=$(ffprobe -i "$video" -show_entries format=duration -v quiet -of csv="p=0")

  # If video length shorter than 45 seconds, move the file to the trash
  (( $(echo "$length < $_VIDEO_LENGTH" | bc -l) )) && echo "$video" && _info "Removed - $video"
done
