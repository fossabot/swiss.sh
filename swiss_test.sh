#!/bin/bash
# this file is part of swiss.sh which is released under the mit license.
# go to http://opensource.org/licenses/mit for full details.

SWISS_TEST_PATH=$(readlink -f ${BASH_SOURCE[0]} | xargs dirname)
source "${SWISS_TEST_PATH}/swiss.sh"

# setup library aliases
assert()      { swiss::test::assert      "${@}"; }
colorize()    { swiss::colorize          "${@}"; }
end_suite()   { swiss::test::end_suite   "${@}"; }
end_test()    { swiss::test::end_test    "${@}"; }
start_suite() { swiss::test::start_suite "${@}"; }
start_test()  { swiss::test::start_test  "${@}"; }

main() {
  # test the swiss library functions and importation of submodules.
  # globals:
  #   none.
  # arguments:
  #   none.
  # returns:
  #   none.
  start_suite "swiss"
    start_test "swiss::colorize() correctly colors messages"
      assert "colorize 0 'example message'" "$(tput setaf 0)example message$(tput sgr0)"
      assert "colorize 1 'example message'" "$(tput setaf 1)example message$(tput sgr0)"
      assert "colorize 2 'example message'" "$(tput setaf 2)example message$(tput sgr0)"
      assert "colorize 3 'example message'" "$(tput setaf 3)example message$(tput sgr0)"
      assert "colorize 4 'example message'" "$(tput setaf 4)example message$(tput sgr0)"
      assert "colorize 5 'example message'" "$(tput setaf 5)example message$(tput sgr0)"
      assert "colorize 6 'example message'" "$(tput setaf 6)example message$(tput sgr0)"
      assert "colorize 7 'example message'" "$(tput setaf 7)example message$(tput sgr0)"
    end_test
    start_test "swiss correctly imports module functions"
      assert "swiss::test::_test" "swiss::test::test() was imported successfully."
    end_test
  end_suite
}

main
