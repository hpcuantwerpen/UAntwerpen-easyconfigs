# UAntwerpen-easyconfigs

This repository contains the EasyConfig files used at the UAntwerpen VSC site. 
They differ from the standard ones available in the 
[easybuilders repositories](https://github.com/easybuilders/easybuild-easyconfigs)
in multiple ways.
* We tend to include more information in the (LMOD) module files for 
  module spider and module help
* We tend to include design decisions in our EasyConfig files
* We sometimes use bundles to put related software and libraries in a single module
  to reduce module clutter for our users or to simply make things work better.
  An example of the former are our [buildtools modules](https://github.com/hpcuantwerpen/UAntwerpen-easyconfigs/tree/master/b/buildtools) 
  that combine many standard build tools (CMake, autoconfig, GNU make, ...) compiled with the
  standard OS compilers and OS libraries. An example of the latter are our 
  [netCDF modules](https://github.com/hpcuantwerpen/UAntwerpen-easyconfigs/tree/master/n/netCDF)
  that include the base libraries and the Fortran and dual C++ interfaces in a single module.

See the [Wiki of this repository](https://github.com/hpcuantwerpen/UAntwerpen-easyconfigs/wiki) for more informaton.

It may be useful to also check our ["EasyBuild - The Missing Manual" OneNote](https://1drv.ms/f/s!AjGZCXJ9iRp3iptoom8jWWypyVu_0g).

## Toolchains / build set

### 2019b toolchains / build set

Given that we started building before EasyBuild 4.0 was released, we decided to stick 
with the 3.9.4 version as otherwise we got an unpleasant number of warnings about
deprecated features. Yet we did start the EasyConfig files in such a way that they 
would be easily portable to the 4.x versions of EasyBuild.

### 2020a toolchains / build set

For this build set we switched to EasyBuild 4.1 and later.

