#!/bin/bash
#
# test.sh

assert_equal() {
  result=$(swiss::colorize 2 pass)
  expect="${1}"
  stdin="${2}"
  command="${3}"
  expect_status="${4:-0}"
  actual=$(echo "${stdin}" | eval "${command}" 2> /dev/null)
  actual_status=$?
  if [[ "${expect}" != "${actual}" ]] \
    || [[ "${expect_status}" != "${actual_status}" ]]; then
  result=$(swiss::colorize 1 fail)
  fi
  echo "${result}:"
  echo "  expect:"
  echo "    output: \"${expect}\""
  echo "    status: ${expect_status}"
  echo "  actual:"
  echo "    output: \"${actual}\""
  echo "    status: ${actual_status}"
}
