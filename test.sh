#!/bin/bash
# this file is part of swiss.sh which is released under the mit license.
# go to http://opensource.org/licenses/mit for full details.

swiss::test::assert() {
  # verify that a command functions correctly via means of comparing stdout,
  # stderr, and exit status.
  # input can be provided to the command via stdin.
  # globals:
  #   none
  # arguments:
  #   $1: name    name to use when displaying test results
  #   $2: command command to execute
  #   $3: stdout  expected string to be produced to stdout
  #   $4: status  expected exit status of the command (default = 0)
  #   $5: stderr  expected string to be produced to stderr (default = "")
  # returns:
  #   none
  # TODO(mraxilus): make sure to return non-zero exit status if any failures
  #                 might want to set TEST_FAILURE and use trap to detect

  # detect if input has been provided
  local stdin=""
  if read -t 0; then
    stdin=$(cat /dev/stdin)
  fi

  local stderr_file=$(mktemp)
  local stdout  # circumvent local discarding exit status
  stdout=$(echo "${stdin}" | eval "${2}" 2> ${stderr_file})
  local exit_status=$?
  local stderr=$(cat ${stderr_file})
  local result="fail"  # assume failure by default
  if [[ "${3}" == "${stdout}" ]] \
    && [[ "${4:-0}" == "${exit_status}" ]] \
    && [[ "${5-${stderr}}" == "${stderr}" ]]; then
    result="pass"
  fi
  swiss::test::_print_result "${result}" "${1}" "${3}" "${4:-0}" \
    "${5-${stderr}}" "${stdout}" "${exit_status}" "${stderr}"

  # cleanup
  # TODO(mraxilus): use a trap
  rm ${stderr_file}
}

swiss::test::assert_status() {
  # TODO(mraxilus): impliment assert_status
  # globals:
  #   none
  # arguments:
  #   $1  name
  #   $1  command
  #   $1  status
  # returns:
  #   none
  echo "unimplimented"
}

swiss::test::assert_stderr() {
  # TODO(mraxilus): impliment assert_stderr
  # globals:
  #   none
  # arguments:
  #   $1  name
  #   $2  command
  #   $3  stderr
  # returns:
  #   none
  echo "unimplimented"
}

swiss::test::assert_stdout() {
  # TODO(mraxilus): impliment assert_stdout
  # globals:
  #   none
  # arguments:
  #   $1  name
  #   $2  command
  #   $3  stdout
  # returns:
  #   none
  echo "unimplimented"
}

swiss::test::setup() {
  SWISS_TEST_DIRECTORY_TEMPORARY="$(mktemp -d)"
  cd "${SWISS_TEST_DIRECTORY_TEMPORARY}"
}

swiss::test::cleanup() {
  cd "${SWISS_TEST_DIRECTORY_ORIGINAL}"
  rm -rf "${SWISS_TEST_DIRECTORY_TEMPORARY}"
}

swiss::test::run() {
  eval "$@" &> /dev/null || true
}

swiss::test::start_suite() {
  SWISS_TEST_PASSED=0
  SWISS_TEST_FAILED=0
  SWISS_TEST_TOTAL=0
}

swiss::test::end_suite() {
  # TODO(mraxilus): log test statuses
  echo "unimplemented"
}

swiss::test::_print_result() {
  # TODO(mraxilus): document _print_result
  # globals:
  #   SWISS_TEST_VERBOSE  if set also be verbose for tests that pass
  # arguments:
  #   $1 test result
  #   $2 test name
  #   $3 expect stdout
  #   $4 expect status
  #   $5 expect stderr
  #   $6 actual stdout
  #   $7 actual status
  #   $8 actual stderr
  # returns:
  #   none
  if [[ "${1}" == "pass" ]]; then
    echo "$(swiss::colorize 2 pass):"
  elif [[ "${1}" == "fail" ]]; then
    echo "$(swiss::colorize 1 fail):"
  fi
  echo "  name: \"${2}\""

  # determine whether to print verbose information
  if [[ -v SWISS_TEST_VERBOSE || "${1}" == "fail" ]]; then
    echo "  expect:"
    echo "    stdout: \"${3}\""
    echo "    status: ${4}"
    echo "    stderr: \"${5}\""
    echo "  actual:"
    echo "    stdout: \"${6}\""
    echo "    status: ${7}"
    echo "    stderr: \"${8}\""
  fi
}
