#!/bin/bash

# Extract all archives found in the working directory
# and remove the archives afterwards
# | Dependencies: fd, trash

# Log Helper
_info()    { echo -e "\033[1m[INFO]\033[0m $1" ; }
_warning() { echo -e "\033[33m[WARNING]\033[0m $1" ; }

# Check whether there are any archives to extract
files=$(fd -d 1 -e zip -e rar | wc -l)
[[ $files -eq 0 ]] && _warning 'No archives found.' && exit

# Extract
fd -0 -d 1 -e zip -e rar | while IFS= read -d '' -r archive; do
  tar -xf "$archive" && _info "Extracted - $archive"
  trash "$archive" && _info "Removed - $archive"
done
