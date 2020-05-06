# ANTs installation instructions

* [ANTs web site](https://stnava.github.io/ANTs/)
* [ANTs on GitHub](https://github.com/ANTsX/ANTs) which also includes the 
  [installation instructions](https://github.com/ANTsX/ANTs/wiki/Compiling-ANTs-on-Linux-and-Mac-OS).

## General information

* ANTs needs [ITK](https://github.com/InsightSoftwareConsortium/ITK) (or [web site itk.org](https://itk.org/))
  or [VTK](https://github.com/Kitware/VTK/releases). 
  If it can't find one of those libraries, it will download and install one.
  By default ANTs will use ITK.
     * ANTs may be very picky about the versions of ITK or VTK. 
       See [towards the bottom of the installation instructions](https://github.com/InsightSoftwareConsortium/ITK)
       for instructions on how to determine the right version number of ITK or VTK.
* There are separate packages to interface ANTs with
    * R: [ANTsR](https://github.com/ANTsX/ANTsR)
    * Python: [ANTsPy](https://github.com/ANTsX/ANTsPy)
* ANTs does include a number of bash, R and Perl scripts.
    * The bash-scripts make heavy use of the ANTSPATH variable and don't search
      for the ANTs executables in the standard PATH.
* ToDo: Document the most important CMake flags as that cannot easily be found in the 
  documentation.

## EasyConfigs

There is support for ANTs in EasyBuild. The EasyBuilders recipes tend to use Python
and a VTK installed through EasyBuild. It is not clear why Python is included as a
dependency as there is no Python code in ANTs. There is however an extension that 
needs to be installed separately that provides a Python interface to ANTs.

This documentation was started with the 2020a build sets, ANTs 2.3.3.

Note that the EasyBuilders recipes often contain patches to fix bugs in ANTs. Many
of these patches seem to be derived from bug in the ANTs GitHub repository and hence
are not needed anymore in the next version or patchlevel of ANTs.

### ANTs 2.3.3 for the 2020a toolchains

* We let the code download the right version of ITK. This does imply that not
  all files needed to install the code are stored in the EasyBuild sources
  subdirectories!
* As we can't see where Python is being used, we don't use the Python dependency
  which is in the EasyBuilders recipes.
* Including baselibs as a dependency doesn't seem to make sense. ITK keeps using
  its own internal versions of certain libraries if we make no changes to the
  CMake flags.

