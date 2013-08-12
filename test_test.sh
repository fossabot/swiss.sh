#!/bin/bash
#
# test_test.sh
# TODO(mraxilus): document header

source swiss.sh

main() {
  # TODO(mraxilus): document main
  # TODO(mraxilus): todo write loop to run through tests
  tests=(\
    # name
    # result expect       actual       command        stdin
    "pass on valid stdout" \
      "pass" "valid" "0" "valid"   "0" "echo valid"   "" \
    "fail on invalid stdout" \
      "fail" "valid" "0" "invalid" "0" "echo invalid" "" \
    "pass on valid stdin" \
      "pass" "valid" "0" "valid"   "0" "cat"          "valid" \
    "fail on invalid stdin" \
      "fail" "valid" "0" "invalid" "0" "cat"          "invalid" \
    # veriy status
      #verify_test "valid" "valid"   "cat" 0
      #verify_test "valid" "valid"   "cat" 1
      #verify_test "valid" "invalid" "cat" 0
  )

  if [[ $((${#tests[@]} % 8)) != 0 ]]; then
    # TODO(mraxilus): provide useful output
    exit 1
  fi

  for i in $(seq 0 $(((${#tests[@]} / 8) - 1))); do
    local index=$((i * 8))
    local name=${tests[$index]}
    local result=${tests[$(($index + 1))]}
    local expect_output=${tests[$(($index + 2))]}
    local expect_status=${tests[$(($index + 3))]}
    local actual_output=${tests[$(($index + 4))]}
    local actual_status=${tests[$(($index + 5))]}
    local command=${tests[$(($index + 6))]}
    local stdin=${tests[$(($index + 7))]}
    local assert_output=$(mimic_output "${result}" "${name}" "${expect_output}" "${expect_status}" "${actual_output}" "${actual_status}")
    assert "${name}" "${assert_output}" "${name}" "${expect_output}" "${stdin}" "${command}"
  done
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
