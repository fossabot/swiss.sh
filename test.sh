#!/bin/bash
# this file is part of swiss.sh which is released under the mit license.
# go to http://opensource.org/licenses/mit for full details.

swiss::test::assert() {
  # verify that command produces expected output given some input via stdin.
  # globals:
  #   SWISS_TEST_PASSED: track failed assertion within test.
  # arguments:
  #   $1: command to execute.
  #   $2: expected string to be produced to stdout.
  #   $3: expected exit status of the command.
  #   $4: expected string to be produced to stderr.
  # returns:
  #   none.

  # detect if input has been provided.
  local stdin=""
  if read -t 0; then
    stdin=$(cat /dev/stdin)
  fi

  # retrieve actual output of command.
  local stderr_file=$(mktemp)
  local stdout  # circumvent local command discarding exit status.
  stdout=$(echo "${stdin}" | eval "${1}" 2> ${stderr_file}) || true  # avoid errexit option.
  local exit_status=$?
  local stderr=$(cat ${stderr_file})
  rm "${stderr_file}"

  # assert that actual outputs match expected.
  local passed
  if [[ "${2}" == "${stdout}" ]] \
    && [[ "${3:-0}" == "${exit_status}" ]] \
    && [[ "${4-${stderr}}" == "${stderr}" ]]; then
    passed=1
  else
    passed=0
    SWISS_TEST_PASSED=0
  fi
  swiss::test::_add_assertion "${passed}" "${1}" "${2}" "${3:-0}" \
    "${4-${stderr}}" "${stdout}" "${exit_status}" "${stderr}"
}

swiss::test::end_suite() {
  # finish current suite and print out statistical results.
  # globals:
  #   SWISS_TEST_FAILURES: print out total test failures.
  #   SWISS_TEST_PASSES: print out total test successes.
  #   SWISS_TEST_TOTAL: print out total amount of tests ran.
  # arguments:
  #   none.
  # returns:
  #   none.
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
  # finish current test, print assertions, and update test statistics.
  # globals:
  #   SWISS_TEST_ASSERTIONS: print out output of test's assertions.
  #   SWISS_TEST_PASSED: check if test has failed assertion.
  #   SWISS_TEST_PASSES: update passed test count.
  #   SWISS_TEST_FAILURES: update failed test count.
  #   SWISS_TEST_TOTAL: update total test count.
  #   SWISS_TEST_DIRECTORY_ORIGINAL: change back to original directory.
  #   SWISS_TEST_DIRECTORY_TEMPORARY: delete directory to cleanup after test.
  # arguments:
  #   none.
  # returns:
  #   none.
  if [[ "${SWISS_TEST_ASSERTIONS}" != "" ]]; then
    echo -e "      assertions:${SWISS_TEST_ASSERTIONS}"
  fi

  # update statistics.
  if [[ "${SWISS_TEST_PASSED}" -eq 1 ]]; then
    SWISS_TEST_PASSES=$((${SWISS_TEST_PASSES:-0} + 1))
    echo "      $(swiss::colorize 2 pass): true"
  else
    SWISS_TEST_FAILURES=$((${SWISS_TEST_FAILURES:-0} + 1))
    echo "      $(swiss::colorize 1 pass): false"
  fi
  SWISS_TEST_TOTAL=$((${SWISS_TEST_TOTAL:-0} + 1))

  # cleanup after test.
  cd "${SWISS_TEST_DIRECTORY_ORIGINAL}"
  rm -rf "${SWISS_TEST_DIRECTORY_TEMPORARY}"
}

swiss::test::run() {
  # run passed in arguments as command ignoring output, and return value.
  # globals:
  #   none.
  # arguments:
  #   $@: command to execute.
  # returns:
  #   none.
  eval "$@" &> /dev/null || true
}

swiss::test::start_suite() {
  # start new suite and reset statistical variables for test tracking.
  # globals:
  #   SWISS_TEST_FAILURES: reset failed test count.
  #   SWISS_TEST_PASSES: reset passed test count.
  #   SWISS_TEST_TOTAL: reset total test count.
  # arguments:
  #   $1: name of suite to start.
  # returns:
  #   none.
  SWISS_TEST_PASSES=0
  SWISS_TEST_FAILURES=0
  SWISS_TEST_TOTAL=0
  echo "suite:"
  echo "  name: \"${1:-unnamed suite}\""
  echo "  tests:"
}

swiss::test::start_test() {
  # start new test and reset relevant variables.
  # globals:
  #   SWISS_TEST_DIRECTORY_ORIGINAL: store working directory for test end.
  #   SWISS_TEST_DIRECTORY_TEMPORARY: create and change to temporary directory.
  #   SWISS_TEST_ASSERTIONS: reset assertion output.
  #   SWISS_TEST_PASSED: set to passed to verify overall test result.
  # arguments:
  #   $1: name of test to start.
  # returns:
  #   none.
  SWISS_TEST_DIRECTORY_ORIGINAL="$(pwd)"
  SWISS_TEST_DIRECTORY_TEMPORARY="$(mktemp -d)"
  cd "${SWISS_TEST_DIRECTORY_TEMPORARY}"
  echo "    - name: \"${1:-unnamed test}\""
  SWISS_TEST_ASSERTIONS="" 
  SWISS_TEST_PASSED=1  # assume pass until assertion failure.
}

swiss::test::_test() {
  # this function exists solely to test the importation of module functions.
  # globals:
  #   none.
  # arguments:
  #   none.
  # returns:
  #   none.
  echo "swiss::test::test() was imported successfully."
}

swiss::test::_add_assertion() {
  # create output from result of assertion and add it to buffer for later use.
  # globals:
  #   SWISS_TEST_VERBOSE: if set also be verbose for tests that pass.
  #   SWISS_TEST_ASSERTIONS: buffer used to store all assertion output for test.
  # arguments:
  #   $1: assertion result (1 if passed, 0 if failed).
  #   $2: executed command.
  #   $3: expected stdout.
  #   $4: expected status.
  #   $5: expected stderr.
  #   $6: actual stdout.
  #   $7: actual status.
  #   $8: actual stderr.
  # returns:
  #   none.

  # determine whether to print assertion information.
  if [[ -v SWISS_TEST_VERBOSE || "${1}" == "0" ]]; then
    if [[ "${1}" == "1" ]]; then
      # TODO(mraxilus): translate ascii quotation to unicode in $2.
      SWISS_TEST_ASSERTIONS+="\n        - $(swiss::colorize 2 command): \"${2}\""
    elif [[ "${1}" == "0" ]]; then
      SWISS_TEST_ASSERTIONS+="\n        - $(swiss::colorize 1 command): \"${2}\""
    fi
    SWISS_TEST_ASSERTIONS+="\n          expect:"
    SWISS_TEST_ASSERTIONS+="\n            stdout: \"${3}\""
    SWISS_TEST_ASSERTIONS+="\n            status: ${4}"
    SWISS_TEST_ASSERTIONS+="\n            stderr: \"${5}\""
    SWISS_TEST_ASSERTIONS+="\n          actual:"
    SWISS_TEST_ASSERTIONS+="\n            stdout: \"${6}\""
    SWISS_TEST_ASSERTIONS+="\n            status: ${7}"
    SWISS_TEST_ASSERTIONS+="\n            stderr: \"${8}\""
  fi
}
