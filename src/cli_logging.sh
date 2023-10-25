#!/bin/bash

# Usage: change_color <color>
# Takes the name of the color to be set and change it.
function change_color {
  tput setaf "${1}"
}

# Reset the terminal color by the default one.
function reset_color() {
  tput sgr0
}

# Usage: colored_msg <msg>
# Takes the message to be printed and the name of the color to be set
# and then reset the default terminal color.
function colored_msg() {
  local msg="$1"
  local color=${2}
  local force_verbose="$3"

  if [[ "$VERBOSE" == "true" ]] || [[ "$force_verbose" == "true" ]]; then
    printf "==========================\\n"
    change_color "$color"
    IFS='&' read -r -a array <<<"$msg"
    for element in "${array[@]}"; do
      echo "$element"
      #printf '%s' "$element"
    done
    reset_color
    printf "\n==========================\\n\\n"
  fi
}

function green_msg() {
  local force_verbose="$2"
  colored_msg "${1}" 2 "$force_verbose"
}

function red_msg() {
  local force_verbose="$2"
  colored_msg "${1}" 1 "$force_verbose"
}

function yellow_msg() {
  local force_verbose="$2"
  colored_msg "${1}" 3 "$force_verbose"
}
