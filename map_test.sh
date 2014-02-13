#!/bin/bash
#
# map_test.sh
# TODO(mraxilus): document header

source swiss.sh

main() {
  # a simple test suite which verifies that swiss' map library functions
  # correctly.
  # globals:
  #   none
  # arguments:
  #   none
  # returns:
  #   none
  assert "map() valid on 1 set, 1 arg" \
    "map \"echo '{0}'\" \"expect\"" "expect"
  assert "map() valid on 1 set, 2 args" \
    "map \"echo '{0} {1}'\" \"exp1 exp2\"" "exp1 exp2"
  assert "map() valid on 2 sets, 1 arg" \
    "map \"echo '{0}'\" \"exp1\" \"exp2\"" "$(echo -e "exp1\nexp2")"
  assert "map() valid on 2 sets, 2 arg" \
    "map \"echo '{0} {1}'\" \"exp1 exp2\" \"exp3 exp4\"" \
    "$(echo -e "exp1 exp2\nexp3 exp4")"
  assert "map() valid on unordered placeholders" \
    "map \"echo '{1} {0}'\" \"exp2 exp1\"" "exp1 exp2"
  assert "map() valid on specified command" \
    "map \"{0} {1}\" \"echo expect\"" "expect"
}

assert() {
  # an alias for swiss::test::assert.
  # globals:
  #   none
  # arguments:
  #   $@  same as swiss::test::assert, verbatim
  # returns:
  #   none
  swiss::test::assert "${@}"
}

map() {
  # an alias for swiss::map.
  # globals:
  #   none
  # arguments:
  #   $@  same as swiss::map, verbatim
  # returns:
  #   none
  swiss::map "${@}"
}

main
