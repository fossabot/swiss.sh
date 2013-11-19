#!/bin/bash
# this file is part of swiss.sh which is released under the mit license.
# go to http://opensource.org/licenses/mit for full details.

swiss::log() {
  # log a colored message to the terminal complete with date and time
  # information in utc format.
  # globals:
  #   none
  # arguments:
  #   $1: message color code (refer to swiss::colorize)
  #   $2: message type
  #   $3: message string
  #   $4: date (default current time)
  # returns:
  #   none
  message_type=$(swiss::colorize "${1}" "${2}")
  utc_time=$(swiss::colorize 4 ${4:-$(date --utc +"%T")})
  echo -e "${message_type} at ${utc_time}: ${3}"
}

swiss::log::debug() {
  # log a debug message to terminal.
  # globals:
  #   none
  # arguments:
  #   $@: arguments to forward to swiss::log excluding color code and type
  # returns:
  #   none
  swiss::log 5 debug "${@}" >&2
}

swiss::log::error() {
  # log an error message to terminal.
  # globals:
  #   none
  # arguments:
  #   $@: arguments to forward to swiss::log excluding color code and type
  # returns:
  #   none
  swiss::log 1 error "${@}" >&2
}

swiss::log::fatal() {
  # log a fatal message to terminal.
  # globals:
  #   none
  # arguments:
  #   $@: arguments to forward to swiss::log excluding color code and type
  # returns:
  #   none
  swiss::log 1 fatal "${@}" >&2
}

swiss::log::info() {
  # log an informational message to terminal.
  # globals:
  #   none
  # arguments:
  #   $@: arguments to forward to swiss::log excluding color code and type
  # returns:
  #   none
  swiss::log 2 "info " "${@}"
}

swiss::log::trace() {
  # log a trace message to terminal.
  # globals:
  #   SWISS_LOG_TRACE
  # arguments:
  #   none
  # returns:
  #   none

  # only log trace messages if variable explicitly set
  if [[ -v SWISS_LOG_TRACE ]]; then
    local path="${FUNCNAME[1]}"
    local size=${#FUNCNAME[@]}
    # iterate through call stack to construct trace message
    for ((i=2; i < size; i++)); do
      path="${FUNCNAME[$i]} -> ${path}"
    done
    swiss::log 4 "trace" "${path}"
  fi
}

swiss::log::warn() {
  # log a warning message to terminal.
  # globals:
  #   none
  # arguments:
  #   $@: arguments to forward to swiss::log excluding color code and type
  # returns:
  #   none
  swiss::log 3 "warn " "${@}" >&2
}
