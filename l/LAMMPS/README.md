# LAMMPS instructions

  * [LAMMPS web site at SANDIA National Labs](https://lammps.sandia.gov/)
  * [LAMMPS development on GitHub](https://github.com/lammps/lammps)
      * [GitHub releases](https://github.com/lammps/lammps/releases)

## General information

  * LAMMPS is configured by first doing make with a number of yes-<package> and/or no-<package> commands.
      * There are also a number of generics that enable/disable all packages simultaneously. So the order is important!
  * The LAMMPS sources consist of two big parts:
     * lib/* subdirectories: Various optional libraries for LAMMPS that need to be build 
       AFTER the configuration of LAMMPS (see below) and BEFORE LAAMMPS is actually build
     * src subdirectory: The main LAMMPS sources where the whole build process of the 
       executables (or libraries, as LAMMPS can also be build as library) take place
        * LAMMPS packages also have corresponding subdirectories
        * However, LAMMPS can also be extended by simply adding C++ source files and 
          corresponding header files, a feature used by UAntwerp users to add 4 sets of 
          2 source files. 
        * PLUMED has a command to copy the necessary files to define a PLUMED package to 
          the LAMMPS sources. We did notice that the PLUMED integration doesn't always 
          work and my require pairing certain specific version of PLUMED with specific 
          versions of LAMMPS. So not all of our modules include PLUMED support.
  

## EasyBuild

We started the development of this information from our internal documentation when 
installing with the 2020a toolchains.

There is [support for LAMMPS in the standard EasyBuild
repository](https://github.com/easybuilders/easybuild-easyconfigs/tree/master/easybuild/easyconfigs/l/LAMMPS).
It uses a specific [EasyBlock for LAMMPS](https://github.com/easybuilders/easybuild-easyblocks/blob/master/easybuild/easyblocks/l/lammps.py).
We did not always rely on that EasyBlock and instead often did a more manual install 
directly steering the build process from the EasyConfig file.

### Version 11Aug2017 for 2020a

  * This is a straight port of the module that we compiled to the 2020a toolchains.
  * We used the patch mechanism to inject a number of files specific to the UAntwerp installation.
  * The remainder of the work was done with a `MakeCp`-based EasyConfig that first executes
    a sequence of `make yes/no-...`- commands to configure LAMMPS before doing the actual
    build. The build in this EasyConfig is done as a single build, but it actually has three 
    phases:
      * Build a parallel version
      * Build a sequential version
      * Build a number of extra tools.
  * We do rely on the OS-provided Python for this build.