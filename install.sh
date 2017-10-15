#!/usr/bin/env bash
set -e

DEVMAC_SUCCESS=""

# Set colors
BOLD='\033[1m'
RED='\033[91m'
GREEN='\033[92m'
BLUE='\033[94m'
ENDC='\033[0m'


# ----------------------------  Output functions  ------------------------------


error_msg() {
  echo -e "${BOLD}${RED}!!! $*${ENDC}" >&2
}

cleanup() {
  set +e
  if [ -z "$DEVMAC_SUCCESS" ]; then
    echo 
    if [ -n "$DEVMAC_STEP" ]; then
      error_msg "$DEVMAC_STEP FAILED"
    else
      error_msg "FAILED"
    fi
  fi
}

# Run the cleanup function above, if there is an error
# or the user aborts the execution
trap "cleanup" EXIT


abort() {
  DEVMAC_STEP=""
  error_msg "$*"
  exit 1
}

log() {
  DEVMAC_STEP="$*"
  echo -e "${BLUE}==>${ENDC} ${BOLD}$*${ENDC}"
}

logn()  { 
  DEVMAC_STEP="$*"
  printf -- "${BLUE}==>${ENDC} ${BOLD}%s${ENDC} " "$*"
}

logk()  {
  DEVMAC_STEP=""
  echo -e "${GREEN}OK${ENDC}"
  echo
}


# ----------------------------  Main functions  --------------------------------


# Function to display a nice header
show_header() {
  echo
  cat << "EOF"
[38;5;184m [0m[38;5;178m_[0m[38;5;214m_[0m[38;5;214m_[0m[38;5;208m_[0m[38;5;208m_[0m[38;5;208m [0m[38;5;203m [0m[38;5;203m [0m[38;5;203m [0m[38;5;198m [0m[38;5;198m [0m[38;5;199m [0m[38;5;199m [0m[38;5;199m [0m[38;5;164m [0m[38;5;164m [0m[38;5;164m [0m[38;5;129m [0m[38;5;129m_[0m[38;5;129m_[0m[38;5;93m [0m[38;5;93m [0m[38;5;99m_[0m[38;5;63m_[0m
[38;5;184m|[0m[38;5;214m [0m[38;5;214m [0m[38;5;208m_[0m[38;5;208m_[0m[38;5;208m [0m[38;5;203m\[0m[38;5;203m [0m[38;5;203m [0m[38;5;198m [0m[38;5;198m [0m[38;5;198m [0m[38;5;199m [0m[38;5;199m [0m[38;5;164m [0m[38;5;164m [0m[38;5;164m [0m[38;5;128m [0m[38;5;129m|[0m[38;5;129m [0m[38;5;93m [0m[38;5;93m\[0m[38;5;93m/[0m[38;5;63m [0m[38;5;63m [0m[38;5;63m|[0m
[38;5;214m|[0m[38;5;214m [0m[38;5;208m|[0m[38;5;208m [0m[38;5;208m [0m[38;5;203m|[0m[38;5;203m [0m[38;5;203m|[0m[38;5;198m [0m[38;5;198m_[0m[38;5;198m_[0m[38;5;199m_[0m[38;5;199m_[0m[38;5;163m_[0m[38;5;164m [0m[38;5;164m [0m[38;5;128m [0m[38;5;129m_[0m[38;5;129m|[0m[38;5;93m [0m[38;5;93m\[0m[38;5;93m [0m[38;5;63m [0m[38;5;63m/[0m[38;5;63m [0m[38;5;33m|[0m[38;5;33m [0m[38;5;33m_[0m[38;5;39m_[0m[38;5;39m [0m[38;5;44m_[0m[38;5;44m [0m[38;5;44m [0m[38;5;43m_[0m[38;5;49m_[0m[38;5;49m_[0m
[38;5;214m|[0m[38;5;214m [0m[38;5;208m|[0m[38;5;208m [0m[38;5;203m [0m[38;5;203m|[0m[38;5;203m [0m[38;5;204m|[0m[38;5;198m/[0m[38;5;198m [0m[38;5;199m_[0m[38;5;199m [0m[38;5;163m\[0m[38;5;164m [0m[38;5;164m\[0m[38;5;164m [0m[38;5;129m/[0m[38;5;129m [0m[38;5;93m/[0m[38;5;93m [0m[38;5;93m|[0m[38;5;63m\[0m[38;5;63m/[0m[38;5;63m|[0m[38;5;33m [0m[38;5;33m|[0m[38;5;33m/[0m[38;5;39m [0m[38;5;39m_[0m[38;5;38m`[0m[38;5;44m [0m[38;5;44m|[0m[38;5;43m/[0m[38;5;49m [0m[38;5;49m_[0m[38;5;48m_[0m[38;5;48m|[0m
[38;5;214m|[0m[38;5;208m [0m[38;5;208m|[0m[38;5;209m_[0m[38;5;203m_[0m[38;5;203m|[0m[38;5;203m [0m[38;5;198m|[0m[38;5;198m [0m[38;5;199m [0m[38;5;199m_[0m[38;5;199m_[0m[38;5;164m/[0m[38;5;164m\[0m[38;5;164m [0m[38;5;129mV[0m[38;5;129m [0m[38;5;129m/[0m[38;5;93m|[0m[38;5;93m [0m[38;5;63m|[0m[38;5;63m [0m[38;5;63m [0m[38;5;33m|[0m[38;5;33m [0m[38;5;33m|[0m[38;5;39m [0m[38;5;39m([0m[38;5;38m_[0m[38;5;44m|[0m[38;5;44m [0m[38;5;44m|[0m[38;5;49m [0m[38;5;49m([0m[38;5;48m_[0m[38;5;48m_[0m
[38;5;208m|[0m[38;5;208m_[0m[38;5;208m_[0m[38;5;203m_[0m[38;5;203m_[0m[38;5;203m_[0m[38;5;198m/[0m[38;5;198m [0m[38;5;199m\[0m[38;5;199m_[0m[38;5;199m_[0m[38;5;164m_[0m[38;5;164m|[0m[38;5;164m [0m[38;5;129m\[0m[38;5;129m_[0m[38;5;129m/[0m[38;5;93m [0m[38;5;93m|[0m[38;5;99m_[0m[38;5;63m|[0m[38;5;63m [0m[38;5;63m [0m[38;5;33m|[0m[38;5;33m_[0m[38;5;39m|[0m[38;5;39m\[0m[38;5;39m_[0m[38;5;44m_[0m[38;5;44m,[0m[38;5;44m_[0m[38;5;49m|[0m[38;5;49m\[0m[38;5;49m_[0m[38;5;48m_[0m[38;5;48m_[0m[38;5;83m|[0m

[38;5;208m=[0m[38;5;203m=[0m[38;5;203m=[0m[38;5;203m=[0m[38;5;198m=[0m[38;5;198m=[0m[38;5;198m=[0m[38;5;199m=[0m[38;5;199m=[0m[38;5;163m=[0m[38;5;164m=[0m[38;5;164m=[0m[38;5;128m=[0m[38;5;129m=[0m[38;5;129m=[0m[38;5;93m=[0m[38;5;93m=[0m[38;5;93m=[0m[38;5;63m=[0m[38;5;63m=[0m[38;5;63m=[0m[38;5;33m=[0m[38;5;33m=[0m[38;5;33m=[0m[38;5;39m=[0m[38;5;39m=[0m[38;5;44m=[0m[38;5;44m=[0m[38;5;44m=[0m[38;5;43m=[0m[38;5;49m=[0m[38;5;49m=[0m[38;5;48m=[0m[38;5;48m=[0m[38;5;84m=[0m[38;5;83m=[0m[38;5;83m=[0m
EOF
  echo
  echo -e "${BOLD}DevMac Installation${ENDC}"
  echo "-------------------------------------"
  echo
}


# Function to get the root user access
get_root() {
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
}


# Function to check and enable full-disk encryption.
check_disk_encryption() {
  logn "Checking full-disk encryption status"
  if fdesetup status | grep $Q -E "FileVault is (On|Off, but will be enabled after the next restart)."; then
    logk
  elif [ -n "$DEVMAC_CI" ]; then
    logn "Skipping full-disk encryption for CI"
  elif [ -n "$DEVMAC_INTERACTIVE" ]; then
    log "Enabling full-disk encryption on next reboot:"
    sudo fdesetup enable -user "$USER" \
      | tee ~/Desktop/"FileVault Recovery Key.txt"
    logk
  else
    abort "Run 'sudo fdesetup enable -user \"$USER\"' to enable full-disk encryption."
  fi
}


# Function to check if the Xcode license is agreed to and agree if not.
xcode_license() {
  if /usr/bin/xcrun clang 2>&1 | grep $Q license; then
    if [ -n "$DEVMAC_INTERACTIVE" ]; then
      logn "Asking for Xcode license confirmation"
      sudo xcodebuild -license
      logk
    else
      abort "Run 'sudo xcodebuild -license' to agree to the Xcode license."
    fi
  fi
}


# Function to install the Xcode Command Line Tools.
install_xcode_commandline_tools() {
  DEVMAC_DIR=$("xcode-select" -print-path 2>/dev/null || true)
  if [ -z "$DEVMAC_DIR" ] || ! [ -f "$DEVMAC_DIR/usr/bin/git" ] \
                          || ! [ -f "/usr/include/iconv.h" ]
  then
    log "Installing the Xcode Command Line Tools"
    CLT_PLACEHOLDER="/tmp/.com.apple.dt.CommandLineTools.installondemand.in-progress"
    sudo touch "$CLT_PLACEHOLDER"
    CLT_PACKAGE=$(softwareupdate -l | \
                  grep -B 1 -E "Command Line (Developer|Tools)" | \
                  awk -F"*" '/^ +\*/ {print $2}' | sed 's/^ *//' | head -n1)
    sudo softwareupdate -i "$CLT_PACKAGE"
    sudo rm -f "$CLT_PLACEHOLDER"
    if ! [ -f "/usr/include/iconv.h" ]; then
      if [ -n "$DEVMAC_INTERACTIVE" ]; then
        logn "Requesting user install of Xcode Command Line Tools"
        xcode-select --install
      else
        abort "Run 'xcode-select --install' to install the Xcode Command Line Tools."
      fi
    fi
    logk
  fi

  xcode_license
}


# Function to check the macOS version
check_macos() {
  logn "Checking macOS version:"
  sw_vers -productVersion | grep -q -E "^10.(9|10|11|12|13)" || {
    abort "Run DevMac on macOS 10.9/10/11/12."
  }
  logk
}


# Function to check the current logged in user
check_user() {
  logn "Checking current user:"
  [ "$USER" = "root" ] && abort "Run DevMac as yourself, not root."
  groups | grep -q admin || abort "Add $USER to the admin group."
  logk
}


# Function to check if git is installed
check_git() {
  logn "Checking git:"
  if ! command -v git 1>/dev/null 2>&1; then
    abort "Git is not installed, can't continue."
  fi
  logk
}


# Function to clone or update zhe devmac repository
clone_repository() {
  local install_location="$2"
  local cwd=$(pwd)
  if [ ! -d "$2" ] ;then
    logn "Cloning git repository $1 into $install_location:"
    git clone "$1" "$2"
  else
    logn "Updating git repository in $install_location:"
    cd "$install_location"
    git pull origin master &> /dev/null
    cd "$cwd"
  fi
  logk
}


# ----------------------------  MAIN  ------------------------------------------


# Show the "devmac" header
show_header

# Check the macOS version
check_macos

# Check the current user
check_user

# Check if git is installed
check_git


# Clone/Update the "devmac" repository into our home directory
clone_repository "https://github.com/joheinemann/devmac.git" "$HOME/.devmac"


DEVMAC_SUCCESS="1"
export DEVMAC_HEADER="1"

# Add the bin path to the global path and bootstrap "devmac"
export PATH="$HOME/.devmac/bin:$PATH"
devmac bootstrap

  
