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
  * LAMMPS packages: There is a lot of useful information in the [Include packages
    in build page of the manual](https://lammps.sandia.gov/doc/Build_package.html)
      * COMPRESS: Needs libz.
      * KIM: Needs kim-api version 2 and libcurl.
      * MESSAGE: [ZeroMQ](https://zeromq.org/) library needed (also known as zmq)
        NOTE: Not yet included as a dependency in the EasyConfigsfor 3Mar2020,
        so likely taken from the system.
      * PYTHON: Speaks for itself, needs a Python installation with working shared
        libraries. The documentation of LAMMPS 10Feb2021 still claims that this
        should be Python 2???
      * VORONOI: Requires the Voro++ library
      * USER-MOLFILE: May need VMD molfile plugin header files ([VMD](https://www.ks.uiuc.edu/Research/vmd/)
        is a visualisation package). LAMMPS ships with defaults but they may work or
        not work with the version of VMD installed on a system.
      * USER-NETCDF needs netCDF installed but should auto-detect the libraries.


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

### Version 3Mar2020 for Intel 2020a

  * *NOTE*: Compile problems on CentOS 7, so only installed on CentOS 8 machines.

  * Started from the EasyBuilders file for this version, but changed the dependencies.
    So it now uses the LAMMPS EasyBlock rather than the MakeCp EasyBlock that we used
    before.
  * Added some options to ``configopts`` to also build some tools that might be needed.
  * The LAMMPS EasyBlock will build the documentation by default which will fail as
    we do not have sphinx-build installed in the 2020a toolchains (after all, we don't
    run a web server to give users access to the web documentation). Therefore we had
    to explicitly add ``-DBUILD_DOC=no`` to ``configopts`` as otherwise the EasyBlock
    will enable the documentation build.
  * Problem: The CMake ``USER-INTEL.cmake`` file forces the use of ``-xHost``. We removed
    that from that file using ``sed`` in ``preconfigopts``.
  * Problem: Kokkos build did not work. Kokkos produced error messages about header
    files that Intel takes from GCC, so we disabled kokkos.
  * Problems with USER-packages:
      * PLUMED: The code fails to add the necessary libraries to the linker command
        line and as a result produces error messages that ``plumed_create``, ``plumed_finalize``
        and ``plumed_cmd_nothrow`` are not defined. These symbols are defined in the
        PLUMED-library ``libplumedWrapper.a``. The solution was to change the PLUMED
        mode to ``shared`` by adding ``-DPLUMED_MODE=shared`` to the CMake command
        line.




