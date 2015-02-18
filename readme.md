[swiss.sh][linkedin] [![build status][travis_image]][travis_status]
=============
_Creating a pocket sized toolkit library for any situation._


Modules
-------
- __Log__ displays formatted info, warn, error, fatal, and trace messages.
- __Map__ runs a function over a list of arguments.
- __Test__ provides simple functions for creating unit tests.


Usage
-----
First, clone swiss to your local directory:

```sh
git clone git@github.com:mraxilus/swiss.sh.git swiss
```

Next, create a test script:

```sh
echo "\
#! /bin/bash

source swiss/swiss.sh

swiss::log::info 'Hello swiss\!'
" > hello_swiss.sh
```

Finally, make your script executable, and run it:

```sh
chmod +x hello_swiss.sh
./hello_swiss.sh
```
Congratulations, you've now imported, and utilized the swiss.sh library.
Now go forth, and be awesome.


Purpose
-------
Hacking together libraries from all over the place can be tiring.
Also, the knowledge gained from the creation of a library is beneficial.
Both of these factors have lead to the development of the utilities in this self-contained library.


License
-------
Copyright © Mr Axilus.
This project is licensed under [CC BY-NC-SA 4.0][license].

[linkedin]: https://www.linkedin.com/in/mraxilus
[travis_image]: https://secure.travis-ci.org/mraxilus/swiss.sh.png?branch=master
[travis_status]: https://travis-ci.org/mraxilus/swiss.sh
[license]: https://creativecommons.org/licenses/by-nc-sa/4.0/
