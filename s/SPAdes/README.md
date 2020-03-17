# SPAdes installation instructions

* [SPAdes website](http://cab.spbu.ru/software/spades/)
* [SPAdes GitHub](https://github.com/ablab/spades)


## General remarks

* GNU C++ is the only compiler supported by the development team (demonstrated also 
  by hard-coded GNU compiler options). Several versions
  don't compile with the Intel compilers, producing tons of warnings and a fatal error.
    * The problem of using ``#import``(an Objective C construct) rather then
      ``#include`` was solved in 3.13, but other problems remained.
* The compiler instructions on the web site are out-of-date, recent versions of SPAdes
  do support CMake.


## EasyConfigs

### 3.13.1 (2018b toolchain)

* SPAdes does not compile correctly with Intel. Hence we used g++ but did chose to 
  keep SPAdes in the Intel toolchain as it does rely on a number of components that were
  compiled with the Intel compilers.
* As there is CMake support in the code, we did use that even though the web site told
  to use a shell script.

### 3.14.0 (2019b toolchain)

* The adaptations were fairly trivial. We just bumped the versions and switched to 
  baselibs for zlib and bzip2.
* Tested again with Intel, but the same problems as with 3.13.1 are still present.
