#!/bin/bash

# Script backing up current configurations with mackup

# Log Helper
_info() { echo -e "\033[1m[INFO]\033[0m $1" ; }

_info "Backing up application settings with mackup"
mackup backup
