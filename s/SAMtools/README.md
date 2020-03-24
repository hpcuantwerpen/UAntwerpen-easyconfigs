# SAMtools installation instructions

* [SAMtools web site]()
* [SAMtools on GitHub]()

## EasyConfigs

This documentation starts with version 1.10 in the 2020a toolchains.

### Version 1.10 for the Intel 2020 toolchains

* Now with support for libdeflate which was added to baselibs but missing
  in older toolchains.
* There is an error message in the config logs about not finding ncursesw.h,
  but this probably doesn't matter since ncursesw/curses.h is found?
* It also complains about the ncurses.h header file. It is not clear how serious
  this error message is. The actual error is an undefined type, ``wint_t``, 
  which actually should come from ``wchar.h``.

