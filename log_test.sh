#!/bin/bash
# this file is part of swiss.sh which is released under the mit license.
# go to http://opensource.org/licenses/mit for full details.

LOG_TEST_PATH=$(readlink -f ${BASH_SOURCE[0]} | xargs dirname)
source "${LOG_TEST_PATH}/swiss.sh"

# setup library aliases
assert()      { swiss::test::assert      "${@}"; }
colorize()    { swiss::colorize          "${@}"; }
end_suite()   { swiss::test::end_suite   "${@}"; }
end_test()    { swiss::test::end_test    "${@}"; }
start_suite() { swiss::test::start_suite "${@}"; }
start_test()  { swiss::test::start_test  "${@}"; }

main() {
  # test log module of the swiss library.
  # globals:
  #   none.
  # arguments:
  #   none.
  # returns:
  #   none.
  start_suite "swiss::log"
    start_test "log() correctly logs messages"
      assert "swiss::log 2 type message time" \
        "$(colorize 2 "type") at $(colorize 4 "time"): message"
      assert "swiss::log 2 type \"multi-word message\" time" \
        "$(colorize 2 "type") at $(colorize 4 "time"): multi-word message"
    end_test

    # test log specializations.
    test_log_specialization_stderr "debug" "5"
    test_log_specialization_stderr "error" "1"
    test_log_specialization_stderr "fatal" "1"
    test_log_specialization_stdout "info " "2"
    test_log_specialization_stderr "warn " "3"

    # TODO(mraxilus): test swiss::log::trace().
  end_suite
}

test_log_specialization_stderr() {
  #
  # globals:
  #   none.
  # arguments:
  #   $1: specialization name
  #   $2: color code
  # returns:
  #   none.
  start_test "log::${1}() correctly logs messages"
    assert "swiss::log::${1} message time" \
      "" \
      "0" \
      "$(colorize "${2}" "${1}") at $(colorize "4" "time"): message"
    assert "swiss::log::${1} \"multi-word message\" time" \
      "" \
      "0" \
      "$(colorize "${2}" "${1}") at $(colorize "4" "time"): multi-word message"
  end_test
}

test_log_specialization_stdout() {
  #
  # globals:
  #   none.
  # arguments:
  #   $1: name of log specialization.
  #   $2: color code to use for expect.
  # returns:
  #   none.
  start_test "log::${1}() correctly logs messages"
    assert "swiss::log::${1} message time" \
      "$(colorize "${2}" "${1}") at $(colorize "4" "time"): message"
    assert "swiss::log::${1} \"multi-word message\" time" \
      "$(colorize "${2}" "${1}") at $(colorize "4" "time"): multi-word message"
  end_test
}

main
