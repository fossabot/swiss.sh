#!/bin/bash
# this file is part of swiss.sh which is released under the mit license.
# go to http://opensource.org/licenses/mit for full details.

set -o nounset
set -o errexit

SWISS_ROOT=$(readlink -f ${BASH_SOURCE[0]} | xargs dirname)
# create array of all submodules excluding tests and this file itself
SWISS_PATHS=($(find ${SWISS_ROOT}/*.sh | sed '/\(swiss\|_test\)\.sh$/d'))
SWISS_SOURCEE=$(readlink -f ${BASH_SOURCE[1]}) 

swiss::colorize() {
  # apply color to a string.
  # globals:
  #   none
  # arguments:
  #   $1:  color code
  #   $2:  string
  # returns:
  #   none
  #
  # the color codes are as follows:
  #   0: black
  #   1: red
  #   2: green
  #   3: yellow
  #   4: blue
  #   5: magenta
  #   6: cyan
  #   7: white
  echo -e "$(tput setaf ${1})${2}$(tput sgr0)"
}

swiss::main() {
  # source all the swiss libraries in the SWISS_ROOT directory
  # globals:
  #   $SWISS_PATHS
  #   $SWISS_SOURCEE
  # arguments:
  #   none
  # returns:
  #   none
  for swiss_path in "${SWISS_PATHS[@]}"; do
    if [[ "${swiss_path}" != "${SWISS_SOURCEE}" ]]; then
      source "${swiss_path}"
    fi
  done
}

swiss::main
