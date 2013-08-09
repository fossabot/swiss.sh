#!/bin/bash
#
# test.sh

# TODO(mraxilus): show output only on failures
# TODO(mraxilus): provide ability to set output verbosity
# TODO(mraxilus): document assert_equal
swiss::test::assert_equal() {
  name="${1}"
  expect_stdout="${2}"
  stdin="${3}"
  command="${4}"
  expect_status="${5:-0}"
  actual_stdout=$(echo "${stdin}" | eval "${command}" 2> /dev/null)
  actual_status=$?
  if [[ "${expect_stdout}" != "${actual_stdout}" ]] \
    || [[ "${expect_status}" != "${actual_status}" ]]; then
    echo "$(swiss::colorize 1 fail):"
    echo "  name: \"${name}\""
    echo "  expect:"
    echo "    output: \"${expect_stdout}\""
    echo "    status: ${expect_status}"
    echo "  actual:"
    echo "    output: \"${actual_stdout}\""
    echo "    status: ${actual_status}"
    return 1
  else
    echo "$(swiss::colorize 2 pass):"
    echo "  name: \"${name}\""
    return 0
  fi
}
