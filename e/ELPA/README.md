# ELPA installation instructions

* [ELPA home page](https://elpa.mpcdf.mpg.de/)
* [ELPA GitLab](https://gitlab.mpcdf.mpg.de/elpa/elpa) hosted by MPG
    + [Installation instructions on the GitLab](https://gitlab.mpcdf.mpg.de/elpa/elpa/blob/master/INSTALL.md)    
* ELPA stands for Eigenvalue soLvers for Petascale Applications
* ELPA libraries can be compiled with or without OpenMP support. Both sets
  of libraries can be installed together as they have different names.
* ELPA can also be build without MPI support, and those libraries get
  "onenode" in their name. Hence MPI and non-MPI OpenMP and non-OpenMP 
  versions can coexist in a single library directory.
* ELPA also contains optional GPU support through CUDA.
* ELPA contains kernels for various CPUs: there is a generic kernel,
  specialized kernels for SSE, AVX, AVX2, AVX512, and some support
  for SPARC64, BlueGene P and BlueGene Q.

## TODOs

It is not clear from the documentation which linear algebra libraries
should be used for the OpenMP versions of the code: Should we use the
multithread version or the singlethread version?

## EasyConfig

First version covered by this documentation: ELPA-2019.11.001-intel-2019b.eb

* Rather then building an EasyBlock for ELPA that could ensure that all
  processor-specific kernels that make sense are enabled, we do this in the
  EasyConfig file based on the value of the ``VSC_ARCH_LOCAL`` environment
  variable. We use a minimal number of kernels.
* Since the libraries with and without OpenMP and with and without MPI
  have different names, we build all (by using an array of configopts in EasyBuild).
* We currently link with matching linear algebra libraries: multithreaded ones
  for the multithreaded ELPA libraries. A user can always set ``MKL_NUM_THREADS``
  to change the number of threads MKL uses independent of ``OMP_NUM_THREADS``
  should it be better to use single threaded linear algebra.
* Other options that were enabled:
    + Single precision support (``--enable-single-precision`)
    + Support for skew-symmetric matrices ( ``--enable-skew-symmetric-support``)
* There is some symbolic linking in the postinstallcmds to ensure that we
  also have a version-independent path within the installation directory
  to the include files and modules.
