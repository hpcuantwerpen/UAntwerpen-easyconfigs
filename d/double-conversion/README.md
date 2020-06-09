# double-conversion instructions

* [double-conversion on GitHub](https://github.com/google/double-conversion)
    * [Releases on Git/hub](https://github.com/google/double-conversion/releases)

## General information

* Version 3.1: There are three build procedures
   * SCons which is advised according to the documentation in the 
     [README.md](https://github.com/google/double-conversion)
     This build three libraries:
        * A static library with regular position-dependent code
        * A static library with position-independent code
        * A shared library
   * CMake: Can build only one library at a time.
   * Makefile: It simply calls scons according to the documentation.

## EasyBuild

There is [ EasyBuild support for double-conversion](https://github.com/easybuilders/easybuild-easyconfigs/tree/develop/easybuild/easyconfigs/d/double-conversion)
In EasyBuild 4.2, the current version when this documentation was started, it is based
on the CMake installation procedure, making three runs to install the three versions 
of the library that SCons generates.

### 3.1.5, 2020a toolchains

* Made a CMake-based EasyConfig using only cosmetic changes to the standard EasyBuilders
  recipe.
* Tried to make a SCons-based version. 
    * It however does not fully work as the 
      include files are not copied to the install directories. This can be fixed
      in a postinstallcmds.
    * And there is also a problem with specifying the install directory.
      The EasyBuild SCons EasyBlock does this by specifying `PREFIX` but
      the scons recipe for double-conversion expects `prefix` instead.
      This can be fixed through `installopts`.
* It turns out that the size of the library files is very different in both cases.
  So the procedures are still far from equivalent...
