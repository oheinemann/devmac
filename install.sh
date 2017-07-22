#!/usr/bin/env bash
set -e

# Keep sudo timestamp updated while DevMac is running.
if [ "$1" = "--sudo-wait" ]; then
  while true; do
    mkdir -p "/var/db/sudo/$SUDO_USER"
    touch "/var/db/sudo/$SUDO_USER"
    sleep 1
  done
  exit 0
fi

Q="-q"

# Set colors
BOLD='\033[1m'
RED='\033[91m'
GREEN='\033[92m'
YELLOW='\033[93m'
BLUE='\033[94m'
ENDC='\033[0m'


cleanup() {
  set +e
  if [ -n "$DEVMAC_SUDO_WAIT_PID" ]; then
    sudo kill "$DEVMAC_SUDO_WAIT_PID"
  fi
  sudo -k
  if [ -z "$DEVMAC_SUCCESS" ]; then
    if [ -n "$DEVMAC_STEP" ]; then
      echo "!!! $DEVMAC_STEP FAILED" >&2
    else
      echo "!!! FAILED" >&2
    fi
  fi
}

# Run the cleanup function above, if there is an error
# or the user aborts the execution
trap "cleanup" EXIT

version="1.0.0"
update="2017/07/07"



# Some debugging functions
abort() { DEVMAC_STEP="";   echo "!!! $*" >&2; exit 1; }
log()   { DEVMAC_STEP="$*"; echo -e "${BLUE}==>${ENDC} ${BOLD}$*${ENDC}"; }
logn()  { DEVMAC_STEP="$*"; printf -- "${BLUE}==>${ENDC} ${BOLD}%s${ENDC} " "$*"; }
logk()  { DEVMAC_STEP="";   echo -e "${GREEN}OK${ENDC}"; echo ; }




check_git() {
  logn "Checking git:"
  if ! command -v git 1>/dev/null 2>&1; then
    abort "Git is not installed, can't continue."
  fi
  logk
}



clone_repository() {
  if [ ! -d "$2" ] ;then
	logn "Cloning git repository $1 into $2:"
    git clone "$1" "$2"
  else
	logn "Updating git repository in $2:"
    git pull --no-rebase --ff
  fi
  logk
}




# Display a pretty header
echo
cat << "EOF"
[38;5;184m [0m[38;5;178m_[0m[38;5;214m_[0m[38;5;214m_[0m[38;5;208m_[0m[38;5;208m_[0m[38;5;208m [0m[38;5;203m [0m[38;5;203m [0m[38;5;203m [0m[38;5;198m [0m[38;5;198m [0m[38;5;199m [0m[38;5;199m [0m[38;5;199m [0m[38;5;164m [0m[38;5;164m [0m[38;5;164m [0m[38;5;129m [0m[38;5;129m_[0m[38;5;129m_[0m[38;5;93m [0m[38;5;93m [0m[38;5;99m_[0m[38;5;63m_[0m
[38;5;184m|[0m[38;5;214m [0m[38;5;214m [0m[38;5;208m_[0m[38;5;208m_[0m[38;5;208m [0m[38;5;203m\[0m[38;5;203m [0m[38;5;203m [0m[38;5;198m [0m[38;5;198m [0m[38;5;198m [0m[38;5;199m [0m[38;5;199m [0m[38;5;164m [0m[38;5;164m [0m[38;5;164m [0m[38;5;128m [0m[38;5;129m|[0m[38;5;129m [0m[38;5;93m [0m[38;5;93m\[0m[38;5;93m/[0m[38;5;63m [0m[38;5;63m [0m[38;5;63m|[0m
[38;5;214m|[0m[38;5;214m [0m[38;5;208m|[0m[38;5;208m [0m[38;5;208m [0m[38;5;203m|[0m[38;5;203m [0m[38;5;203m|[0m[38;5;198m [0m[38;5;198m_[0m[38;5;198m_[0m[38;5;199m_[0m[38;5;199m_[0m[38;5;163m_[0m[38;5;164m [0m[38;5;164m [0m[38;5;128m [0m[38;5;129m_[0m[38;5;129m|[0m[38;5;93m [0m[38;5;93m\[0m[38;5;93m [0m[38;5;63m [0m[38;5;63m/[0m[38;5;63m [0m[38;5;33m|[0m[38;5;33m [0m[38;5;33m_[0m[38;5;39m_[0m[38;5;39m [0m[38;5;44m_[0m[38;5;44m [0m[38;5;44m [0m[38;5;43m_[0m[38;5;49m_[0m[38;5;49m_[0m
[38;5;214m|[0m[38;5;214m [0m[38;5;208m|[0m[38;5;208m [0m[38;5;203m [0m[38;5;203m|[0m[38;5;203m [0m[38;5;204m|[0m[38;5;198m/[0m[38;5;198m [0m[38;5;199m_[0m[38;5;199m [0m[38;5;163m\[0m[38;5;164m [0m[38;5;164m\[0m[38;5;164m [0m[38;5;129m/[0m[38;5;129m [0m[38;5;93m/[0m[38;5;93m [0m[38;5;93m|[0m[38;5;63m\[0m[38;5;63m/[0m[38;5;63m|[0m[38;5;33m [0m[38;5;33m|[0m[38;5;33m/[0m[38;5;39m [0m[38;5;39m_[0m[38;5;38m`[0m[38;5;44m [0m[38;5;44m|[0m[38;5;43m/[0m[38;5;49m [0m[38;5;49m_[0m[38;5;48m_[0m[38;5;48m|[0m
[38;5;214m|[0m[38;5;208m [0m[38;5;208m|[0m[38;5;209m_[0m[38;5;203m_[0m[38;5;203m|[0m[38;5;203m [0m[38;5;198m|[0m[38;5;198m [0m[38;5;199m [0m[38;5;199m_[0m[38;5;199m_[0m[38;5;164m/[0m[38;5;164m\[0m[38;5;164m [0m[38;5;129mV[0m[38;5;129m [0m[38;5;129m/[0m[38;5;93m|[0m[38;5;93m [0m[38;5;63m|[0m[38;5;63m [0m[38;5;63m [0m[38;5;33m|[0m[38;5;33m [0m[38;5;33m|[0m[38;5;39m [0m[38;5;39m([0m[38;5;38m_[0m[38;5;44m|[0m[38;5;44m [0m[38;5;44m|[0m[38;5;49m [0m[38;5;49m([0m[38;5;48m_[0m[38;5;48m_[0m
[38;5;208m|[0m[38;5;208m_[0m[38;5;208m_[0m[38;5;203m_[0m[38;5;203m_[0m[38;5;203m_[0m[38;5;198m/[0m[38;5;198m [0m[38;5;199m\[0m[38;5;199m_[0m[38;5;199m_[0m[38;5;164m_[0m[38;5;164m|[0m[38;5;164m [0m[38;5;129m\[0m[38;5;129m_[0m[38;5;129m/[0m[38;5;93m [0m[38;5;93m|[0m[38;5;99m_[0m[38;5;63m|[0m[38;5;63m [0m[38;5;63m [0m[38;5;33m|[0m[38;5;33m_[0m[38;5;39m|[0m[38;5;39m\[0m[38;5;39m_[0m[38;5;44m_[0m[38;5;44m,[0m[38;5;44m_[0m[38;5;49m|[0m[38;5;49m\[0m[38;5;49m_[0m[38;5;48m_[0m[38;5;48m_[0m[38;5;83m|[0m

EOF
echo -e "${BOLD}DevMac Installation${ENDC}"
echo "====================================="
echo -e "Release:     ${BOLD}$version${ENDC}"
echo -e "Last update: ${BOLD}${update}${ENDC}"
echo "-------------------------------------"
echo


DEVMAC_SUCCESS=""


# Check the macOS version
logn "Checking macOS version:"
sw_vers -productVersion | grep $Q -E "^10.(9|10|11|12)" || {
	abort "Run DevMac on macOS 10.9/10/11/12."
}
logk

# Check the current logged in user
logn "Checking current user:"
[ "$USER" = "root" ] && abort "Run DevMac as yourself, not root."
groups | grep $Q admin || abort "Add $USER to the admin group."
logk

# Get the full path of the script
DEVMAC_FULL_PATH="$(cd "$(dirname "$0")" && pwd)/$(basename "$0")"

# Initialise sudo now to save prompting later.
log "Enter your password (for sudo access)"
sudo -k
sudo /usr/bin/true
[ -f "$DEVMAC_FULL_PATH" ]
sudo bash "$DEVMAC_FULL_PATH" --sudo-wait &
DEVMAC_SUDO_WAIT_PID="$!"
ps -p "$DEVMAC_SUDO_WAIT_PID" &>/dev/null
logk


DEVMAC_SUCCESS="1"


echo
echo -e "${BOLD}Your system is now READY!${ENDC}"
echo