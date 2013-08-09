#!/bin/bash
#
# test_test.sh
# TODO(mraxilus): document header

source swiss.sh

main() {
  # TODO(mraxilus): document main
  # TODO(mraxilus): todo write loop to run through tests
  tests=(\
    "name" "pass" "o1" "s1" "o2" "s2" "command" "stdin" \
  )
  local name="pass on matching expect"
  local expect=$(mimic_output "pass" "${name}")
  assert "${name}" "${expect}" "${name}" "valid" "" "echo valid"
  #verify_test "valid" "" "echo invalid" 

  # verify stdin
  #verify_test "valid" "valid"     "cat" 
  #verify_test "valid" "invalid" "cat" 

  # veriy status
  #verify_test "valid" "valid"     "cat" 0
  #verify_test "valid" "valid"     "cat" 1
  #verify_test "valid" "invalid" "cat" 0
}

mimic_output() {
  # TODO(mraxilus): document mimic_output
  # TODO(mraxilus): clean up layout of expect
  local expect=""
  if [[ "${1}" == "pass" ]]; then
    expect+="$(swiss::colorize 2 pass):\n  name: \"${2}\""
  elif [[ "${1}" == "fail" ]]; then
    expect+="$(swiss::colorize 1 fail):\n  name: \"${2}\"\n  expect:\n    "
    expect+="output: \"${3}\"\n    status: ${4}\n  actual:\n    output: "
    expect+="\"${5}\"\n    status: ${6}"
  fi
  echo -e "$expect"
}

assert() {
  # TODO(mraxilus): document verify_test
  local name="${1}"
  shift
  local expect="${1}"
  shift
  local actual=$(swiss::test::assert_equal "${@}")
  if [[ "${expect}" == "${actual}" ]]; then
    echo "$(swiss::colorize 2 pass):"
    echo "  name: \"${name}\""
  else
    echo "$(swiss::colorize 1 fail):"
    echo "  name: \"${name}\""
    exit 1
  fi
}

main
