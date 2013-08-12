#!/bin/bash
#
# test_test.sh
# TODO(mraxilus): document header

source swiss.sh

main() {
  # TODO(mraxilus): document main
  local tests=(\
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
    "pass on valid status" \
      "pass" "valid" "0" "valid"   "0" "cat"          "valid" \
    "fail on invalid status" \
      "fail" "valid" "1" "valid"   "0" "cat"          "valid" \
  )

  if [[ $((${#tests[@]} % 8)) != 0 ]]; then
    # TODO(mraxilus): provide useful output
    swiss::log::error "malformed test cases"
    exit 1
  fi

  for i in $(seq 0 $(((${#tests[@]} / 8) - 1))); do
    local j=$((i * 8))
    local assert_output=$(mimic_output "${tests[@]:$j:$(($j + 7))}")
    assert "${assert_output}" "${tests[@]:$j:$(($j + 7))}"
  done
}

mimic_output() {
  # TODO(mraxilus): document mimic_output
  local expect=""
  if [[ "${2}" == "pass" ]]; then
    expect+="$(swiss::colorize 2 pass):"
    expect+="\n  name: \"${1}\""
  elif [[ "${2}" == "fail" ]]; then
    expect+="$(swiss::colorize 1 fail):"
    expect+="\n  name: \"${1}\""
    expect+="\n  expect:"
    expect+="\n    stdout: \"${3}\""
    expect+="\n    status: ${4}"
    # TODO(mraxilus): mimic stderr
    expect+="\n    stderr: \"\""
    expect+="\n  actual:"
    expect+="\n    stdout: \"${5}\""
    expect+="\n    status: ${6}"
    expect+="\n    stderr: \"\""
  fi
  echo -e "${expect}"
}

assert() {
  # TODO(mraxilus): document assert
  local expect="${1}"
  local actual=$(echo "${9}" | swiss::test::assert "${2}" "${8}" "${4}" "${5}")
  if [[ "${expect}" == "${actual}" ]]; then
    echo "$(swiss::colorize 2 pass):"
    echo "  name: \"${2}\""
  else
    echo "$(swiss::colorize 1 fail):"
    echo "  name: \"${2}\""
    exit 1
  fi
}

main
