#!/bin/bash
#
# map.sh

swiss::map() {
  # TODO(mraxilus): document swiss::map
  local args
  local command
  for element in "${@:2}"; do
    command="${1}"
    args=("${(s/ /)element}")
    i=0
    for arg in "${args[@]}"; do
      command=$(echo "${command}" \
        | sed "s/\(.*\){${i}}\(.*\)/\1${arg}\2/")
      i=$((${i} + 1))
    done
    eval "${command}"
  done
}

# swiss::map "command {0} {1}" "arg0 arg1" "arg0 arg1"
