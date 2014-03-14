[swiss.sh][1] [![build status][2]][3] [![gitter][4]][5] [![waffle][6]][7]
=============
_a pocket sized library toolkit for any situation._

modules
-------
- __log__ displays formatted info, warn, error, fatal, and trace messages.
- __map__ runs a function over a list of arguments.
- __test__ provides simple functions for creating unit tests.

usage
-----
first,
  clone swiss to your local directory:

```sh
git clone git@github.com:mraxilus/swiss.sh.git swiss
```

next,
  create a test script:

```sh
echo "\
#! /bin/bash

source swiss/swiss.sh

swiss::log::info 'hello swiss\!'
" > hello_swiss.sh
```

finally,
  make your script executable, and run it:

```sh
chmod +x hello_swiss.sh
./hello_swiss.sh
```
congratulations,
  you've now successfully imported,
  and utilized the swiss.sh library.
now go forth,
  and be awesome.

purpose
-------
hacking together libraries from all over the place can be tiring,
  and the knowledge gained from the creation of a library is beneficial.
thus,
  the development of useful utilities packaged in one self-contained library.

documentation
-------------
for more information please consult the [wiki][8]. 
you will also find elaborated descriptions of each tool.

license
-------
copyright © mr axilus.
<a class="coinbase-button" data-code="c060c048abd9fe7b4f36021738451bed" data-button-style="donation_small" href="https://coinbase.com/checkouts/c060c048abd9fe7b4f36021738451bed">sponsor</a> with bitcoins.

permission is hereby granted,
  free of charge,
  to any person obtaining a copy of this software and associated documentation files (the "software"),
  to deal in the software without restriction,
  including without limitation the rights to use,
  copy,
  modify,
  merge,
  publish,
  distribute,
  sublicense,
  and/or sell copies of the software,
  and to permit persons to whom the software is furnished to do so,
  subject to the following conditions:

the above copyright notice and this permission notice shall be included in all copies or substantial portions of the software.

the software is provided "as is",
  without warranty of any kind,
  express or implied,
  including but not limited to the warranties of merchantability,
  fitness for a particular purpose and noninfringement.
in no event shall the authors or copyright holders be liable for any claim,
  damages or other liability,
  whether in an action of contract,
  tort or otherwise,
  arising from,
  out of or in connection with the software or the use or other dealings in the software.


<!-- extrenal project page -->
[1]: mraxil.us "swiss.sh"

<!-- travis -->
[2]: https://secure.travis-ci.org/mraxilus/swiss.sh.png?branch=master
[3]: https://travis-ci.org/mraxilus/swiss.sh

<!-- gitter -->
[4]: http://badges.gitter.im/mraxilus/swiss.sh.png
[5]: https://gitter.im/mraxilus/swiss.sh

<!-- waffle. -->
[6]: https://badge.waffle.io/mraxilus/swiss.sh.png?label=ready&title=ready
[7]: https://badge.waffle.io/mraxilus/swiss.sh

<!-- wiki -->
[8]: https://github.com/mraxilus/swiss.sh/wiki
