#!/bin/bash
#
# log.sh

swiss::log() {
  # log a colored message to the terminal complete with date and time
  # information in utc format.
  # globals:
  #   none
  # arguments:
  #   $1: color code
  #   $2: message type
  #   $3: string to log
  # returns:
  #   none
  message_type=$(swiss::colorize "${1}" "${2}")
  utc_time=$(swiss::colorize 4 $(date --utc +"%T"))
  echo -e "${message_type} at ${utc_time}: ${3}"
}

swiss::log_debug() {
  # log a debug message to terminal.
  # globals:
  #   none
  # arguments:
  #   $1: string to log
  # returns:
  #   none
  swiss::log 5 debug "${1}" >&2
}

swiss::log_error() {
  # log an error message to terminal.
  # globals:
  #   none
  # arguments:
  #   $1: string to log
  # returns:
  #   none
  swiss::log 1 error "${1}" >&2
}

swiss::log_fatal() {
  # log a fatal message to terminal.
  # globals:
  #   none
  # arguments:
  #   $1  string to log
  # returns:
  #   none
  swiss::log 1 fatal "${1}" >&2
}

swiss::log_info() {
  # log an informational message to terminal.
  # globals:
  #   none
  # arguments:
  #   $1  string to log
  # returns:
  #   none
  swiss::log 2 "info " "${1}"
}

swiss::log_trace() {
  # log a trace message to terminal.
  # globals:
  #   none
  # arguments:
  #   $1  string to log
  # returns:
  #   none
  local path="${FUNCNAME[1]}"
  local size=${#FUNCNAME[@]}
  for ((i=2; i < size; i++)); do
    path="${FUNCNAME[$i]} -> ${path}"
  done
  swiss::log 4 "trace" "${path}"
}

swiss::log_warn() {
  # log a warning message to terminal.
  # globals:
  #   none
  # arguments:
  #   $1  string to log
  # returns:
  #   none
  swiss::log 3 "warn " "${1}" >&2
}
