# re2c instructions

* [re2c web site](http://re2c.org/), which is also the main documentation web site.
* [re2c on GitHub](https://github.com/skvadrik/re2c)
   * [latest release](https://github.com/skvadrik/re2c/releases)

re2c is a free and open-source lexer generator for C and C++.

Its main goal is generating fast lexers: at least as fast as their reasonably 
optimized hand-coded counterparts. Instead of using traditional table-driven 
approach, re2c encodes the generated finite state automata directly in the 
form of conditional jumps and comparisons. The resulting programs are faster 
and often smaller than their table-driven analogues, and they are much easier 
to debug and understand. re2c applies quite a few optimizations in order to 
speed up and compress the generated code.

Another distinctive feature is its flexible interface: instead of assuming a 
fixed program template, re2c lets the programmer write most of the interface 
code and adapt the generated lexer to any particular environment.

## General information

* re2c has a very standard configure - make - make install build process
  and no particular dependencies.

## EasyBuild

There is support for re2c in the 
[EasyBuilders repository](https://github.com/easybuilders/easybuild-easyconfigs/tree/develop/easybuild/easyconfigs/r/re2c).

At UAntwerp, we started from those recipes but switched to the SYSTEM toolchain
and included the package in our buildtools module.

One user of re2c is Qt5.
