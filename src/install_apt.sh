#!/usr/bin/env bash

# Usage: ensure_apt_pkg <PKG> <APT_UPDATE>
# Takes the name of a package to install if not already installed,
# and optionally a 1 if apt update should be run after installation
# has finished.
ensure_apt_pkg() {
  local apt_package_name="${1}"
  local execute_apt_update="${2}"

  # Install apt package if apt package is not yet installed.
  if [[ "$(apt_package_is_installed "$apt_package_name")" != "FOUND" ]]; then
    yellow_msg " ${apt_package_name} is not installed. Installing now."
    sudo apt --assume-yes install "${apt_package_name}" >>/dev/null 2>&1
  else
    green_msg " ${apt_package_name} is installed"
  fi

  verify_apt_installed "${apt_package_name}"

  if [ "$execute_apt_update" == "1" ]; then

    green_msg "Performing apt update"

    # Since apt repositories are time stamped
    # we need to enforce the time is set correctly before doing
    # an update - this can easily fail in virtual machines, otherwise
    # TODO: fix:force_update_of_time
    sudo apt update >>/dev/null 2>&1
  fi
}

# Verifies apt package is installed.
verify_apt_installed() {
  local apt_package_name="$1"

  # Throw error if apt package is not yet installed.
  if [[ "$(apt_package_is_installed "$apt_package_name")" != "FOUND" ]]; then
    red_msg "Error, the apt package ${apt_package_name} is not installed." "true"
    exit 3 # TODO: update exit status.
  else
    green_msg "Verified apt package ${apt_package_name} is installed."
  fi
}
