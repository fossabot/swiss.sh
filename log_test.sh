#!/bin/bash

source swiss.sh

# setup library aliases
assert()   { swiss::test::assert "${@}"; }
colorize() { swiss::colorize     "${@}"; }

main() {
  swiss::test::start_suite

  # swiss::log()
  assert "log() correctly logs single word message" \
    "swiss::log 2 type message time" \
    "$(colorize 2 "type") at $(colorize 4 "time"): message"
  assert "log() correctly logs multi-word message" \
    "swiss::log 2 type \"multi-word message\" time" \
    "$(colorize 2 "type") at $(colorize 4 "time"): multi-word message"

  # log specializations
  test_log_specialization_stderr "debug" "5"
  test_log_specialization_stderr "error" "1"
  test_log_specialization_stderr "fatal" "1"
  test_log_specialization_stdout "info " "2"
  test_log_specialization_stderr "warn " "3"

  # swiss::trace()
  # TODO(mraxilus): test trace

  swiss::test::end_suite
}

test_log_specialization_stderr() {
  # globals:
  #   none
  # arguments:
  #   $1: specialization name
  #   $2: color code
  # returns:
  #   none
  assert "log::${1}() correctly logs single word message" \
    "swiss::log::${1} message time" \
    "" \
    "0" \
    "$(colorize "${2}" "${1}") at $(colorize "4" "time"): message"
  assert "log::${1}() correctly logs multi-word message" \
    "swiss::log::${1} \"multi-word message\" time" \
    "" \
    "0" \
    "$(colorize "${2}" "${1}") at $(colorize "4" "time"): multi-word message"
}

test_log_specialization_stdout() {
  # globals:
  #   none
  # arguments:
  #   $1: specialization name
  #   $2: color code
  # returns:
  #   none
  assert "log::${1}() correctly logs single word message" \
    "swiss::log::${1} message time" \
    "$(colorize "${2}" "${1}") at $(colorize "4" "time"): message"
  assert "log::${1}() correctly logs multi-word message" \
    "swiss::log::${1} \"multi-word message\" time" \
    "$(colorize "${2}" "${1}") at $(colorize "4" "time"): multi-word message"
}

main
