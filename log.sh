#!/bin/bash
#
# log.sh

# log logs a colored message to the terminal complete with date and time
# information in utc format.
#   $1  color code
#   $2  message type
#   $3  string to log
swiss::log() {
  message_type=$(swiss::log_colorize "${1}" "${2}")
  utc_date=$(swiss::log_colorize 3 $(date --utc +"%Y-%b-%d" \
    | tr "[A-Z]" "[a-z]"))
  utc_time=$(swiss::log_colorize 4 $(date --utc +"%T"))
  echo -e "${message_type} on ${utc_date} at ${utc_time}:  ${3}"
}

# colorize applies color to string.
#   $1  color code
#   $2  string
#
# the color codes are as follows:
#   0  black
#   1  red
#   2  green
#   3  yellow
#   4  blue
#   5  magenta
#   6  cyan
#   7  white
swiss::log_colorize() {
   echo -e "$(tput setaf ${1})${2}$(tput sgr0)"
}

# log error message to terminal.
#   $1  string to log
swiss::log_error() {
  swiss::log 1 error "${1}" >&2
}

# log error message to terminal.
#   $1  string to log
swiss::log_fatal() {
  swiss::log 1 fatal "${1}" >&2
}

# log info message to terminal.
#   $1  string to log
swiss::log_info() {
  swiss::log 2 "info " "${1}"
}

# log info message to terminal.
#   $1  string to log
swiss::log_trace() {
  local path="${FUNCNAME[1]}"
  local size=${#FUNCNAME[@]}
  for ((i=2; i < size; i++)); do
    path="${FUNCNAME[$i]} -> ${path}"
  done
  swiss::log 4 "trace" "${path}"
}

# log info message to terminal.
#   $1  string to log
swiss::log_warn() {
  swiss::log 3 "warn " "${1}" >&2
}
