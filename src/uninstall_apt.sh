#!/usr/bin/env bash

# 0.a Install prerequisites for Nextcloud.
# 0.b Verify prerequisites for Nextcloud are installed.
apt_remove() {
  local apt_package_name="$1"

  yellow_msg "Removing ${apt_package_name} if it is installed."

  sudo apt purge "$apt_package_name" -y >>/dev/null 2>&1

  verify_apt_removed "$apt_package_name"
}

apt_package_is_installed() {
  local apt_package_name="$1"

  # Get the number of packages installed that match $1
  local num
  num=$(dpkg -l "$apt_package_name" 2>/dev/null | grep -c -E '^ii')

  if [ "$num" -eq 1 ]; then
    echo "FOUND"
  elif [ "$num" -gt 1 ]; then
    echo "More than one match"
    exit 1
  else
    echo "NOTFOUND"
  fi
}

# Verifies apt package is removed
verify_apt_removed() {
  local apt_package_name="$1"

  # Throw error if package still is installed.
  if [[ "$(apt_package_is_installed "$apt_package_name")" == "NOTFOUND" ]]; then
    green_msg "Verified the apt package ${apt_package_name} is removed."
  else
    red_msg "Error, the apt package ${apt_package_name} is still installed." "true"
    exit 3 # TODO: update exit status.
  fi
}

##################################################################
# Purpose: Clean up APT environment
# Arguments:
#   None
##################################################################
function cleanup() {
  sudo apt clean >/dev/null

  # Auto remove any remaining unneeded apt packages.
  sudo apt autoremove >>/dev/null 2>&1

  # Fix any remaining broken installations.
  sudo apt -f install >>/dev/null 2>&1
}
