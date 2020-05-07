#!/bin/bash

# Log Helper
_info()    { echo -e "\033[1m[INFO]\033[0m $1" ; }
_ok()      { echo -e "\033[32m[OK]\033[0m $1" ; }
_warning() { echo -e "\033[33m[WARNING]\033[0m $1" ; }
_error()   { echo -e "\033[31m[ERROR]\033[0m $1" ; }
