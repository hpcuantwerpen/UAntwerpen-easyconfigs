# OpenFOAM installation instructions

* The organisation behind OpenFOAM is a bit of a mess. One thing is for sure: there 
  is the [OpenFOAM Foundation](https://openfoam.org/) which is a vehicle created by
  the original developers to promote and manage the free, open source distribution
  of OpenFOAM when that company (OpenCFD) was sold to Silicon Graphics.
* However, nowadays two companies maintain a code base and claim to be the prime
  developer.
    * [CFD Direct](https://cfd.direct/) claims to be the manager and primary developer
      on behalf of the OpenFOAM Foundation. They release the version with low version 
      numbers (at the time of writing OpenFOAM 7).
        * [Development repository on GitHub](https://github.com/OpenFOAM/OpenFOAM-dev) 
          and there is always a release repository
          in [the OpenFOAM GitHub](https://github.com/OpenFOAM) 
          named after the last version number.
    * [OpenCFD Ltd](https://www.openfoam.com/) which is in fact the original developer
      that got first absorbed by SGI but later got sold again to ESI Group. 
      release versions numberd "vYYMM" (e.g., v1912).
        * [GitLab code repository](https://develop.openfoam.com/explore/projects) 
* Both of these companies also provide commercial support for OpenFOAM.

## General information

### Dependencies

* It is very unclear which are the mandatory dependencies and which ones are optional.
  The list differs depending on where you look in the documentation.
* [Scotch](https://gforge.inria.fr/projects/scotch/) version 6 seems to be mandatory.
* [Metis](http://glaros.dtc.umn.edu/gkhome/metis/metis/overview) 
  seems to be a dependency also. I wonder if this is an EasyBuild issue where 
  some EasyBuild developers think that Scotch needs it (while Scotch actually has its
  built-in version of Metis)
* FFTW is also an optional dependency according to the 
  [system requirements section](https://www.openfoam.com/documentation/system-requirements.php)
  on OpenFOAM.com. It is not clear if it also recognizes MKL FFT.
* [CGAL](https://www.cgal.org/): The [system requirements section](https://www.openfoam.com/documentation/system-requirements.php)
  on OpenFOAM.com suggests that this is an optional dependency, but it is 
  not clear which options of CGAL are really needed. For a cluster installation where
  it will run in batch mode, it looks unlikely the GUI parts will be needed as they
  can impossibly work in distributed mode. CGAL needs Boost.
* [ParaView](https://www.paraview.org/): The system requirements on OpenFOAM.com suggest
  this is an optional component. The [build guide on OpenFOAM.com](https://www.openfoam.com/code/build-guide.php)
  is clear that this can be omitted if using other post-processing software.

### Building OpenFOAM

* I found some pages on OpenFOAM.com particularly useful
    * [OpenFOAM installation from source](https://www.openfoam.com/download/install-source.php)
      with also a link to a
      [system requirements section](https://www.openfoam.com/documentation/system-requirements.php)
    * OpenFOAM.com also includes a [build guide](https://www.openfoam.com/code/build-guide.php)
    * Yet I am still missing a page that actually tells how to configure for the
      compiler on the system, etc.
* To make life difficult it comes with its own, poorly documented, configuration tool
  ``wmake`` which isn't even called directly but through another script, Allwmake.
* It looks like several options are set through editing the /etc/bashrc file in the
  OpenFOAM distribution rather than command line options of the configuration tool...

### Other remarks

* At the bottom of the [system requirements section](https://www.openfoam.com/documentation/system-requirements.php)
  on OpenFOAM.com there is a remark that says to use ``LD_PRELOAD``
  when using Intel MPI: ``export LD_PRELOAD="libmpi.so"``.

## Building with EasyBuild

### The OpenFOAM EasyBlock

* The block supports two modes, and it distinguishes between them based on the 
  module name: "OpenFOAM" and "OpenFOAM-Extend". TODO: Figure out the difference
  as it is not properly documented.
* The EasyBlock currently only supports GCC and Intel (April 2020). The code supports
  a lot more compilers.
* ``use_mpi`` should not be set in the ``toolchainopts`` as the EasyBlock needs to 
  know booth the sequential and MPI compilers and used the CC/CXX and MPICC/MPICXX 
  environment variables respectively for that purpose.
* There is an extensive sanity check in the EasyBlock. The problem is that the 
  EasyBlock itself seems to support versions of the code that do not correspond
  to the list of files used in the sanity check. It is always possible to avoid
  the sanity check in the EasyBlock by setting your own ``sanity_check_files``
  in the EasyConfig file.
* Looking at the code of the EasyBlock confirms that it tries to set an 
  environment variable to enable a parallel build based on the value of 
  the EasyBuild parameter ``parallel``. However, when monitoring the compile,
  parallel computation doesn't seem to work. It is not clear if this is a problem
  with the EasyBlock. (Maybe -j is needed with Allwmake/wmake, though that will
  overwrite the environment variable that sets the level of parallelism?)

### Version 4.1, installed in 2017

* Did not use ParaView
* Used a modified CGAL EasyBuild recipe with all OpenGL and Qt components thrown
  out as they don't make sense on compute nodes
* Manual intervention after installation: Outcomment the line that loads the 
  settings for ParaView in OpenFOAM-4.1/etc/bashrc.

### Version 6 with Intel 2019b

* Official dependencies in [ThirdParty-6](https://github.com/OpenFOAM/ThirdParty-6)
     * [Scotch 6.0.6](https://www.labri.fr/perso/pelegrin/scotch/)
     * [ParaView](https://github.com/Kitware/ParaView) 5.4.0
     * [CGAL 4.10](https://github.com/CGAL/cgal/tree/releases/CGAL-4.10.2), compiled with Boost 1.55.0
     * [libccmio 2.6.1](https://portal.nersc.gov/svn/visit/trunk/third_party/libccmio-2.6.1.tar.gz): 
       Not clear what this is needed for.
* We stuck to CGAL 4.10, but used a more recent Boost (1.70.0), used Scots 6.0.7 which 
  should only be a patchlevel upgrade and hence not really different. Since none of 
  the EasyBuild builds we looked at includes libccmio, we didn't use it. We also include
  Metis which is an optional dependency.
* The recipe is a mix of the recipe used on the VSC Tier-1 system and our recipe for
  version 4.1. We omitted all GUI stuff as in our 4.1 recipe, but used for the dependencies
  versions that were very close to those used on the Tier-1.
* This compiles correctly with the Intel 2019b compilers.


### Version v1912 with the 2019b toolchain.

Does not work. There are definitely MPI link problems as the wrappers are not always 
used, but it is not clear if that is the only problem.

