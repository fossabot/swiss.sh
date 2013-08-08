#!/bin/bash
#
# swiss.sh

SWISS_ROOT=$(readlink -f ${BASH_SOURCE[0]} | xargs dirname)
SWISS_PATHS=($(find ${SWISS_ROOT}/*.sh | sed '/\(swiss\|_test\)\.sh$/d'))

for swiss_path in "${SWISS_PATHS[@]}"; do
  source "${swiss_path}"
done
