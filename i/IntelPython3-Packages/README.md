# IntelPython3-Packages

These EasyBuild recipes install the packages that are included in the
regular Python 3 packages in this repositoriy but not in the releases
of Intel Python in those toolchains. So after loading IntelPython3-Packages,
you should get Intel Python 3 and a set of packages that is a superset of
those in the regular Python module(s) of that toolchain, though some versions
of packages may be older as they are taken from the Intel Distribution for 
Python.


## 2020a modules

* Used the Intel compiler rather than GCC. This did solve problems with tables.
* Needed to use HDF5 1.10 instead of HDF5 1.12, even though the 1.12 version 
  worked in our regular Python module...

