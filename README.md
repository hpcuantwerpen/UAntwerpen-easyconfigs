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
  
  It may be useful to also check our ["EasyBuild - The Missing Manual" OneNote](https://1drv.ms/f/s!AjGZCXJ9iRp3iptoom8jWWypyVu_0g).
