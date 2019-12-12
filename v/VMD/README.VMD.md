# Installing VMD @ UAntwerp

## General info

* [VMD web site](https://www.ks.uiuc.edu/Research/vmd/)
* [VMD documentation](https://www.ks.uiuc.edu/Research/vmd/current/docs.html): 
     * the instructions to install from source are not in the
       [VMD Installation Guide](https://www.ks.uiuc.edu/Research/vmd/current/ig/ig.html) but in the
       [VMD Programmer's Guide](http://www.ks.uiuc.edu/Research/vmd/doxygen/) (at least 
       for version 1.9.3 which was the most recent released version when this document was
       written)
     * And some of the requirements are only explained properly in the
       [VMD User's Guide]().

VMD has an EasyBlock as the build process has some additional steps due to the
required installation of plug-ins and some other dependencies that come with the
code. It also tries to auto-generate a number of options for the configure command.
Those options are also given in a special way.

## Problems met installing 1.9.3 with EasyBuild 3.9.4 (2019b)

* There is an error in the EasyBlock in the Python statement that calls `numpy.get_includes()`: 
  it is not compatible with Python 3. Correction: Add parentheses to the `print` statement: 
  `python -c 'import numpy; print( numpy.get_include() )'`
* The EasyBlock does not set `PYTHON_INCLUDE_DIR` to the correct directory. E.g., for
  Python 3.7 it should be `$EBROOTPYHTON/include/python3.7m' rather than 
  `$EBROOTPYTHON/include/python3.7`(lacking the `m` at the end). I modified the 
  EasyBlock to distinguish between Python 2 and 3.
* Moreover, Python is an optional component of VMD while the EasyBlock makes this a 
  mandatory one. I've made modifications to make this an optional component.
* VMD does not yet compile with Python 3.7. There are problems with some header files.
  It is not clear if earlier 3.x-versions are supported. The documentation is very 
  unclear on the necessary software.
* netCDF should also be an optional component and I've modified the EasyBlock in 
  that way. However, currently the build procedure fails when no netCDF module is
  specified because the list of plugins is not properly adapted and the build
  procedure tries to build plugins that do require netCDF.
* I've also added a custom parameter '`vmd_arch`' to set the VMD architecture. The 
  default and only one tested is '`LINUXAMD64`'.
* I've also added a second custom parameter, '`vmd_extra_ops`' that is used to specify
  additional options for the build process as it is impossible to specify them through
  '`configopts`'. The problem with `configopts` is that the options are added at the 
  wrong position which causes the build process to fail (they are added before the
  architecture options which should always be the first one).
