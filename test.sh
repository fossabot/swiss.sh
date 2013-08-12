#!/bin/bash
#
# test.sh

# TODO(mraxilus): show output only on failures
# TODO(mraxilus): provide ability to set output verbosity

swiss::test::assert() {
  # detect if input has been provided
  if read -t 0; then
    local stdin=$(cat /dev/stdin)
  fi

  local stderr_file=$(mktemp)
  local stdout  # hack to get around local elminating exit status
  stdout=$(echo "${stdin}" | eval "${2}" 2> ${stderr_file})
  local exit_status=$?
  local stderr=$(cat ${stderr_file})
  local result="fail"
  if [[ "${3}" == "${stdout}" ]] \
    && [[ "${4:-0}" == "${exit_status}" ]] \
    && [[ "${5:-${stderr}}" == "${stderr}" ]]; then
    result="pass"
  fi
  swiss::test::_print_result "${result}" "${1}" "${3}" "${4}" "${5}" \
    "${stdout}" "${exit_status}" "${stderr}"

  # cleanup
  rm ${stderr_file}
}

swiss::test::assert_status() {
  # TODO(mraxilus): impliment assert_status
  echo "unimplimented"
}

swiss::test::assert_stderr() {
  # TODO(mraxilus): impliment assert_stderr
  echo "unimplimented"
}

swiss::test::assert_stdout() {
  # TODO(mraxilus): impliment assert_stdout
  echo "unimplimented"
}

swiss::test::_print_result() {
  # TODO(mraxilus): document _print_result
  if [[ "${1}" == "pass" ]]; then
    echo "$(swiss::colorize 2 pass):"
    echo "  name: \"${2}\""
  elif [[ "${1}" == "fail" ]]; then
    echo "$(swiss::colorize 1 fail):"
    echo "  name: \"${2}\""
    echo "  expect:"
    echo "    stdout: \"${3}\""
    echo "    status: ${4}"
    echo "    stderr: \"${5}\""
    echo "  actual:"
    echo "    stdout: \"${6}\""
    echo "    status: ${7}"
    echo "    stderr: \"${8}\""
  else
    # TODO(mraxilus): report error
    echo "unimplimented"
  fi
}
