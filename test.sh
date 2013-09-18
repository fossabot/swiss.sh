#!/bin/bash
#
# test.sh
# TODO(mraxilus): document header

swiss::test::assert() {
  # TODO(mraxilus): document assert
  # globals:
  #   none
  # arguments:
  #   $1  name
  #   $1  command
  #   $1  stdout
  #   $1  status
  #   $1  stderr
  # returns:
  #   none

  # detect if input has been provided
  if read -t 0; then
    local stdin=$(cat /dev/stdin)
  fi

  local stderr_file=$(mktemp)
  local stdout  # hack to get around local discarding exit status
  stdout=$(echo "${stdin}" | eval "${2}" 2> ${stderr_file})
  local exit_status=$?
  local stderr=$(cat ${stderr_file})
  local result="fail"
  if [[ "${3}" == "${stdout}" ]] \
    && [[ "${4:-0}" == "${exit_status}" ]] \
    && [[ "${5-${stderr}}" == "${stderr}" ]]; then
    result="pass"
  fi
  swiss::test::_print_result "${result}" "${1}" "${3}" "${4:-0}" \
    "${5-${stderr}}" "${stdout}" "${exit_status}" "${stderr}"

  # cleanup
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
