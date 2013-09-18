#!/bin/bash
#
# map_test.sh

source swiss.sh

main() {
  # assert "name" "map arg" "out" "0" ""
  assert "valid output on 1 set, 1 arg" "map \"echo '{0}'\" \"expect\"" \
    "expect" "0" ""
  assert "valid output on 1 set, 2 args" \
    "map \"echo '{0} {1}'\" \"exp1 exp2\"" "exp1 exp2" "0" ""
  assert "valid output on 2 sets, 1 arg" \
    "map \"echo '{0}'\" \"exp1\" \"exp2\"" "$(echo -e "exp1\nexp2")" "0" ""
  assert "valid output on 2 sets, 2 arg" \
    "map \"echo '{0} {1}'\" \"exp1 exp2\" \"exp3 exp4\"" \
    "$(echo -e "exp1 exp2\nexp3 exp4")" "0" ""
}

assert() {
  swiss::test::assert "${@}"
}

map() {
  swiss::map "${@}"
}

main
