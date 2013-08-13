#[swiss.sh][1] ![build status.][2]
*a pocket sized library toolkit for any situation*

## tools
* clone - copy a single file to multiple destinations.
* log - display formatted info, warn, error, fatal, and trace messages.
* map - run a function over a list of arguments.
* test - simple functions for creating unit tests.

## usage
first, clone swiss to your local directory:
```sh
git clone git@github.com:mraxilus/swiss.sh.git swiss
```

next, create a script called `hello_swiss.sh`:
```sh
#!/bin/bash

source swiss/swiss.sh

swiss::log::info "hello swiss!"
```

finally, make your script executable, and run it:
```sh
> chmod +x hello_swiss.sh
> ./hello_swiss.sh
info at 00:00:00: hello swiss!
```
congratulations, you've now successfully imported, and utilized the swiss.sh
library. now go forth. be awesome.

## purpose
i'm tired of hacking together libraries from all over the place. not only can
I benifit from the knowledge gained from the creation of these libraries, but
having a bunch of useful utilities in one neatly integrated self-contained
library is a major plus.

## documentation
for more information please consult the [wiki][3]. you will also find elaborated
descriptions of each tool.

## license
copyright © mr axilus <a class="coinbase-button" data-code="c060c048abd9fe7b4f36021738451bed" data-button-style="donation_small" href="https://coinbase.com/checkouts/c060c048abd9fe7b4f36021738451bed">donate bitcoins</a><script src="https://coinbase.com/assets/button.js" type="text/javascript"></script>

permission is hereby granted, free of charge, to any person obtaining a copy of
this software and associated documentation files (the "software"), to deal in
the software without restriction, including without limitation the rights to
use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
the software, and to permit persons to whom the software is furnished to do so,
subject to the following conditions:

the above copyright notice and this permission notice shall be included in all
copies or substantial portions of the software.

the software is provided "as is", without warranty of any kind, express or
implied, including but not limited to the warranties of merchantability, fitness
for a particular purpose and noninfringement. in no event shall the authors or
copyright holders be liable for any claim, damages or other liability, whether
in an action of contract, tort or otherwise, arising from, out of or in
connection with the software or the use or other dealings in the software.

[1]: mraxil.us "swiss.sh"
[2]: https://secure.travis-ci.org/mraxilus/swiss.sh.png?branch=master
[3]: https://github.com/mraxilus/swiss.sh/wiki
[4]: http://api.flattr.com/button/flattr-badge-large.png
[5]: https://flattr.com/profile/mraxilus
