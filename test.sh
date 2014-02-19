#!/bin/bash
# this file is part of swiss.sh which is released under the mit license.
# go to http://opensource.org/licenses/mit for full details.

swiss::test::assert() {
  # verify that command produces expected output given some input via stdin.
  # globals:
  #   none
  # arguments:
  #   $1: command to execute
  #   $2: expected string to be produced to stdout
  #   $3: expected exit status of the command (default = 0)
  #   $4: expected string to be produced to stderr (default = actual stderr)
  # returns:
  #   none

  # detect if input has been provided
  local stdin=""
  if read -t 0; then
    stdin=$(cat /dev/stdin)
  fi

  local stderr_file=$(mktemp)
  local stdout  # circumvent local discarding exit status
  stdout=$(echo "${stdin}" | eval "${1}" 2> ${stderr_file})
  local exit_status=$?
  local stderr=$(cat ${stderr_file})
  rm "${stderr_file}"
  local result="fail"  # assume failure by default
  if [[ "${2}" == "${stdout}" ]] \
    && [[ "${3:-0}" == "${exit_status}" ]] \
    && [[ "${4-${stderr}}" == "${stderr}" ]]; then
    result="pass"
  else
    SWISS_TEST_PASSED=0
  fi
  swiss::test::_add_assertion "${result}" "${1}" "${2}" "${3:-0}" \
    "${4-${stderr}}" "${stdout}" "${exit_status}" "${stderr}"
}

swiss::test::end_suite() {
  #
  # globals:
  #   SWISS_TEST_FAILURES
  #   SWISS_TEST_PASSES
  #   SWISS_TEST_TOTAL
  # arguments:
  #   none
  # returns:
  #   none
  local results="    fail: ${SWISS_TEST_FAILURES}"
  results="${results}"$'\n'"    pass: ${SWISS_TEST_PASSES}"
  results="${results}"$'\n'"    total: ${SWISS_TEST_TOTAL}"
  if [[ "${SWISS_TEST_FAILURES}" -eq 0 ]]; then  # all tests passed.
    echo "  $(swiss::colorize 2 results):"
    echo "${results}"
  else
    echo "  $(swiss::colorize 1 results):"
    echo "${results}"
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
  if [[ "${SWISS_TEST_ASSERTIONS}" != "" ]]; then
    echo -e "      assertions:${SWISS_TEST_ASSERTIONS}"
  fi

  # update statistics
  if [[ "${SWISS_TEST_PASSED}" -eq 1 ]]; then
    SWISS_TEST_PASSES=$((${SWISS_TEST_PASSES:-0} + 1))
    echo "      $(swiss::colorize 2 pass): true"
  else
    SWISS_TEST_FAILURES=$((${SWISS_TEST_FAILURES:-0} + 1))
    echo "      $(swiss::colorize 1 pass): false"
  fi
  SWISS_TEST_TOTAL=$((${SWISS_TEST_TOTAL:-0} + 1))

  # cleanup after test
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
  #   SWISS_TEST_FAILURES: resets the failed test count 
  #   SWISS_TEST_PASSES: resets the passed test count
  #   SWISS_TEST_TOTAL: resets the total test count
  # arguments:
  #   $1: name of the suite to start
  # returns:
  #   none
  SWISS_TEST_PASSES=0
  SWISS_TEST_FAILURES=0
  SWISS_TEST_TOTAL=0
  echo "suite:"
  echo "  name: \"${1:-unnamed suite}\""
  echo "  tests:"
}

swiss::test::start_test() {
  # 
  # globals:
  #   SWISS_TEST_DIRECTORY_ORIGINAL:
  #   SWISS_TEST_DIRECTORY_TEMPORARY:
  # arguments:
  #   $1: name of test
  # returns:
  #   none
  SWISS_TEST_DIRECTORY_ORIGINAL="$(pwd)"
  SWISS_TEST_DIRECTORY_TEMPORARY="$(mktemp -d)"
  cd "${SWISS_TEST_DIRECTORY_TEMPORARY}"
  echo "    - name: \"${1:-unnamed test}\""
  SWISS_TEST_ASSERTIONS="" 
  SWISS_TEST_PASSED=1  # assume pass until assertion failure.
}

swiss::test::_add_assertion() {
  # TODO(mraxilus): document _add_assertion
  # globals:
  #   SWISS_TEST_VERBOSE:  if set also be verbose for tests that pass.
  # arguments:
  #   $1: test result
  #   $2: command
  #   $3: expect stdout
  #   $4: expect status
  #   $5: expect stderr
  #   $6: actual stdout
  #   $7: actual status
  #   $8: actual stderr
  # returns:
  #   none

  # determine whether to print assertion information
  if [[ -v SWISS_TEST_VERBOSE || "${1}" == "fail" ]]; then
    if [[ "${1}" == "pass" ]]; then
      # TODO(mraxilus): translate ascii quotation to unicode in $2.
      SWISS_TEST_ASSERTIONS+="\n        - $(swiss::colorize 2 command): \"${2}\""
    elif [[ "${1}" == "fail" ]]; then
      SWISS_TEST_ASSERTIONS+="\n        - $(swiss::colorize 1 command): \"${2}\""
    fi
    SWISS_TEST_ASSERTIONS="\n          expect:"
    SWISS_TEST_ASSERTIONS="\n            stdout: \"${3}\""
    SWISS_TEST_ASSERTIONS="\n            status: ${4}"
    SWISS_TEST_ASSERTIONS="\n            stderr: \"${5}\""
    SWISS_TEST_ASSERTIONS="\n          actual:"
    SWISS_TEST_ASSERTIONS="\n            stdout: \"${6}\""
    SWISS_TEST_ASSERTIONS="\n            status: ${7}"
    SWISS_TEST_ASSERTIONS="\n            stderr: \"${8}\""
  fi
}
