#!/bin/sh

# Remove videos, if the video length is shorter than _VIDEO_LENGTH in seconds

_VIDEO_LENGTH=45.0

function __move_to_trash() {
  echo "Deleting $file ($length)"
  trash "$file"
}

# Loop over every video file in the current folder and subfolders
for file in $(find . -type f \( -iname \*.mkv -o -iname \*.mp4 \)); do
  # Get video length in seconds
  length=$(ffprobe -i "$file" -show_entries format=duration -v quiet -of csv="p=0")

  # If video length shorter than 45 seconds, move the file to the trash
  (( $(echo "$length < $_VIDEO_LENGTH" | bc -l) )) && __move_to_trash()
done
