# SAMtools installation instructions

  * [SAMtools web site](http://www.htslib.org/)
  * [SAMtools on GitHub](https://github.com/samtools/samtools)


## General information

  * Note that some time ago SAMtools was split in three different packages
      * HTSlib
      * SAMtools itself
      * BCFtools
      * Which inspired us to bundle them again...
  * SAMtools contains a number of binaries, a static libraries, several Perl 
    scripts but also two LUA scripts.


## EasyConfigs

This documentation starts with version 1.10 in the 2020a toolchains.

There is [support for SAMtools in the EasyBuilders
repository](https://github.com/easybuilders/easybuild-easyconfigs/tree/master/easybuild/easyconfigs/s/SAMtools).
The support uses an EasyBlock that installs a library and include file that are 
not installed by `make install`.


### Version 1.10 for the Intel 2020 toolchains

  * Moved to the BioTools bundle, but there is an EasyBuild recipe here
    for the Bundle development.
  * HTSlib is linked from the appropriate module. That module is compiled
    with support for various compression libraries through the baselibs module.
  * There is an error message in the config logs about not finding ncursesw.h,
    but this probably doesn't matter since ncursesw/curses.h is found?
  * It also complains about the ncurses.h header file. It is not clear how serious
    this error message is. The actual error is an undefined type, ``wint_t``, 
    which actually should come from ``wchar.h``.
  * REMARK: The LUA-dependency is still missing, so the two commands that are in
    fact LUA scripts will not work.
