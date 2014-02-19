#!/bin/bash
# this file is part of swiss.sh which is released under the mit license.
# go to http://opensource.org/licenses/mit for full details.

swiss::test::assert() {
  # verify that command produces expected output given some input via stdin.
  # globals:
  #   none
  # arguments:
  #   $1: name to use when displaying test results
  #   $2: command to execute
  #   $3: expected string to be produced to stdout
  #   $4: expected exit status of the command (default = 0)
  #   $5: expected string to be produced to stderr (default = actual stderr)
  # returns:
  #   none

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
  rm "${stderr_file}"
  local result="fail"  # assume failure by default
  if [[ "${3}" == "${stdout}" ]] \
    && [[ "${4:-0}" == "${exit_status}" ]] \
    && [[ "${5-${stderr}}" == "${stderr}" ]]; then
    result="pass"
    SWISS_TEST_PASSED=$((${SWISS_TEST_PASSED:-0} + 1))
  else
    SWISS_TEST_FAILED=$((${SWISS_TEST_FAILED:-0} + 1))
  fi
  SWISS_TEST_TOTAL=$((${SWISS_TEST_TOTAL:-0} + 1))
  swiss::test::_print_result "${result}" "${1}" "${3}" "${4:-0}" \
    "${5-${stderr}}" "${stdout}" "${exit_status}" "${stderr}"
}

swiss::test::end_suite() {
  #
  # globals:
  #   SWISS_TEST_FAILED
  #   SWISS_TEST_PASSED
  #   SWISS_TEST_TOTAL
  # arguments:
  #   none
  # returns:
  #   none
  local result="  failed: ${SWISS_TEST_FAILED}"
  result="${result}"$'\n'"  passed: ${SWISS_TEST_PASSED}"
  result="${result}"$'\n'"  total: ${SWISS_TEST_TOTAL}"
  if [[ "${SWISS_TEST_FAILED}" -eq 0 ]]; then  # all tests passed.
    echo "$(swiss::colorize 2 result):"
    echo "${result}"
  else
    echo "$(swiss::colorize 1 result):"
    echo "${result}"
    trap "exit 1" EXIT
  fi
}

swiss::test::end_test() {
  # 
  # globals:
  #   SWISS_TEST_DIRECTORY_ORIGINAL:
  #   SWISS_TEST_DIRECTORY_TEMPORARY:
  # arguments:
  #   none
  # returns:
  #   none
  cd "${SWISS_TEST_DIRECTORY_ORIGINAL}"
  rm -rf "${SWISS_TEST_DIRECTORY_TEMPORARY}"
}

swiss::test::run() {
  # run passed in arguments as command ignoring output and return value.
  # globals:
  #   none
  # arguments:
  #   $@: command to execute
  # returns:
  #   none
  eval "$@" &> /dev/null || true
}

swiss::test::start_suite() {
  # resets test tracking variables to separate suite statistical information.
  # globals:
  #   SWISS_TEST_FAILED: resets the failed test count 
  #   SWISS_TEST_PASSED: resets the passed test count
  #   SWISS_TEST_TOTAL: resets the total test count
  # arguments:
  #   none
  # returns:
  #   none
  SWISS_TEST_PASSED=0
  SWISS_TEST_FAILED=0
  SWISS_TEST_TOTAL=0
}

swiss::test::start_test() {
  # 
  # globals:
  #   SWISS_TEST_DIRECTORY_ORIGINAL:
  #   SWISS_TEST_DIRECTORY_TEMPORARY:
  # arguments:
  #   none
  # returns:
  #   none
  SWISS_TEST_DIRECTORY_ORIGINAL="$(pwd)"
  SWISS_TEST_DIRECTORY_TEMPORARY="$(mktemp -d)"
  cd "${SWISS_TEST_DIRECTORY_TEMPORARY}"
}

swiss::test::_print_result() {
  # TODO(mraxilus): document _print_result
  # globals:
  #   SWISS_TEST_VERBOSE:  if set also be verbose for tests that pass.
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
