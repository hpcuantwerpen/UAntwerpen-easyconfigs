# LMDB instructions

* [LMDB web site](https://symas.com/lmdb/)
* [GitHub mirror of the code](https://github.com/LMDB/lmdb)

## General information

* LMDB comes without a configure script, only a Makefile
   * The Makefile does support `make install` but of course 
     `prefix` needs to be redefined.
   * The Makefile doesn't honour compiler-related environment
     flags. Hence the need to redefine CC and OPT when calling 
     make to build the code. Re-defining CFLAGS may be dangerous
     as the Makefile doesn't only use the optimization options but
     adds various options that are necessary.

## EasyBuild information

This information starts with our 0.9.24 EasyConfigs

There is support for LMDB in the EasyBuilders repositories. However,
that support uses the MakeCp generic EasyBlock rather than the install
target in the Makefile. It also copies `midl.h` which on inspection is
only used internally in LMDB and not copies by the install Makefile
target.

### 0.9.22

Our EasyConfigs were based on those from the EasyBuilders repositories

### 0.9.24 in the 2020a toolchains.

* Moved to baselibs to reduce module clutter
* Switched to a ConfigureMake generic EasyBlock to use the install target
  from the Makefile.
   * Required skipping the configure step
   * Required adding the definition of `prefix` when calling `make install`.
   * Required a correction of the sanity_check from the EasyBuilders recipes
     as `midl.h` is not installed.

