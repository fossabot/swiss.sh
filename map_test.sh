#!/bin/bash
# this file is part of swiss.sh which is released under the mit license.
# go to http://opensource.org/licenses/mit for full details.

MAP_TEST_PATH=$(readlink -f ${BASH_SOURCE[0]} | xargs dirname)
source "${MAP_TEST_PATH}/swiss.sh"

# setup library aliases
assert()      { swiss::test::assert      "${@}"; }
end_suite()   { swiss::test::end_suite   "${@}"; }
end_test()    { swiss::test::end_test    "${@}"; }
map()         { swiss::map               "${@}"; }
start_suite() { swiss::test::start_suite "${@}"; }
start_test()  { swiss::test::start_test  "${@}"; }

main() {
  # test map module of the swiss library.
  # globals:
  #   none.
  # arguments:
  #   none.
  # returns:
  #   none.
  start_suite "swss::map"
    start_test "map() valid with argument set of size 1"
      assert "map \"echo '{0}'\" \"expect\"" "expect"
      assert "map \"echo '{0}'\" \"exp1\" \"exp2\"" "$(echo -e "exp1\nexp2")"
    end_test
    start_test "map() valid with argument set of size greater than 1"
      assert "map \"echo '{0} {1}'\" \"exp1 exp2\"" "exp1 exp2"
      assert "map \"echo '{0} {1}'\" \"exp1 exp2\" \"exp3 exp4\"" \
             "$(echo -e "exp1 exp2\nexp3 exp4")"
      assert "map \"echo '{1} {0}'\" \"exp2 exp1\"" "exp1 exp2"
    end_test
    start_test "map() valid on apply function"
      assert "map \"{0} {1}\" \"echo expect\"" "expect"
    end_test
  end_suite
}

main
