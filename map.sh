#!/bin/bash
# this file is part of swiss.sh which is released under the mit license.
# go to http://opensource.org/licenses/mit for full details.

swiss::map() {
  # TODO(mraxilus): document swiss::map
  # globals:
  #   none
  # arguments:
  #   $1    command
  #   $@:2  set of argument collections to map against the command
  # returns:
  #   none
  # example:
  #   > swiss::map "echo '{1} {0}'" "b a" "d c"
  #   a b
  #   c d
  local args
  local command
  for element in "${@:2}"; do
    command="${1}"
    args=(${element})
    local i=0
    for arg in "${args[@]}"; do
      command=$(echo "${command}" \
        | sed "s/\(.*\){${i}}\(.*\)/\1${arg}\2/")
      i=$((${i} + 1))
    done
    eval "${command}"
  done
}
