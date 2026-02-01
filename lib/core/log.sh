log()     { printf "\n\033[1;34m==>\033[0m %s\n" "$*"; }
warn()    { printf "\033[1;33m[warn]\033[0m %s\n" "$*"; }
ok()      { printf "\033[1;32m[ok]\033[0m %s\n" "$*"; }
changed() { printf "\033[1;33m[changed]\033[0m %s\n" "$*"; }
fail()    { printf "\033[1;31m[failed]\033[0m %s\n" "$*"; exit 1; }
