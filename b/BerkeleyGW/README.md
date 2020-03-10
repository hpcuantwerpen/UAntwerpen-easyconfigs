# BerkeleyGW installation notes

This file was started with the development of the EasyConfig for version 2.1 
in the Intel 2019b toolchain.

Earlier EasyConfig files are developed from the default easybuilders 
files but with additional documentation added to the module.

## EasyConfig

### General remarks

There is no formula to compute the download link. The link can be recovered
from [https://berkeleygw.org/download/](https://berkeleygw.org/download/).

### Version 2.1

* The download link is different from previous version. The link on the download
  page takes you to a previewer where you have to click download again. See the
  EasyConfig for the trick that worked to construct a working download link from
  the URL copied on the ["Download" page](https://berkeleygw.org/download/).
* The patch `BerkeleyGW-1.2.0_fix_intent.patchBerkeleyGW-1.2.0_fix_intent.patch`` 
  for the wrong intent of certain Fortran declarations in one of the 
  Sigma source files is no longer needed. That file has been corrected.
* The patch ``BerkeleyGW-2.0.0_fix_path.patch`` does not work with version 2.1.
  The block in the Makefile is now further down, and the file manual.html does no
  longer exist. Hence the patch has been modified to copy the whole documentation
  directory (using ``cp -r``).
