#!/bin/bash
#
# test_test.sh
# TODO(mraxilus): document header

source swiss.sh

main() {
  # TODO(mraxilus): document main
  local name="pass on matching expect"
  local expect="$(swiss::colorize 2 pass):
  name: \"${name}\""
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

#mimic_output() {
  # TODO(mraxilus): document mimic_output
#}

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
