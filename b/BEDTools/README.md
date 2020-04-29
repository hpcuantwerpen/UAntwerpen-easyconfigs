# BEDTools installation instructions

* [bedtools 2 web site](https://bedtools.readthedocs.io/en/latest/)
* [bedtools development on GitHub](https://github.com/arq5x/bedtools2)


## General information

* Bedtools (as of version 2.29) is not using a Autotools or CMake script to
  configure the code. It only contains a complicated Makefile.
  It does have a ``make install prefix=...` though.
* It claims to use HTSLib since version 2.28. It cannot use it as a separate
  library though but includes the source code. In fact, in version 2.29, 
  this turns out to be a rather old version of HTSlib that still contains
  a number of routines that are not present anymore in recent versions
  but are used by the code.
* In good bio-informatics tradition, compilers and compiler flags are
  hardcoded in the Makefiles in a way that sometimes makes it tricky to
  replace them with the correct ones (even though the main Makefile adds
  options in CXXFLAGS to the end of the compiler flags).
* Given the number of warnings during the compile that return flags of
  functions called are not used, I have serious doubts about the robustness
  of that code.
* To compile bedtools, one needs to redefine CXX, CC and CFLAGS during the
  build step and CXX during the install step as it links the library
  again during that step and needs to use the right compiler.
    * CXX is for the main bedtools code.
    * CC and CFLAGS need to be defined on the make command line for HTSlib.
