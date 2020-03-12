# DFTB+ installation instructions

* [DFTB+ web site](https://www.dftbplus.org/)
* [DFTB+ GitHub](https://github.com/dftbplus/dftbplus)
* Dependencies
    * The usual linear algebra stuff: BLAS/LAPACK/ScaLAPACK
    * Python (at least 2.6) with NumPy is needed for the tests. 
    * Optional: [ELSI library](https://wordpress.elsi-interchange.org/)
    * Optional: ARPACK-ng library for excited state DFTB functionality
    * Optional: DftD3 dispersion library (if you need this dispersion model)
    * There are however a lot more dependencies if you look in the external
      subdirectory after asking the code to download the dependencies.
* GPU acceleration is possible

## General installation instructions

* The install procedure downloads optional dependencies, but ELSI and ARPACK-ng
  don't seem to be among them.
* There is no formal configure step. The code is configured by copying one of the
  example make.arch files from the sys subdirectory to make.arch in the main source
  directory and editing it.

## EasyConfigs

The first EasyConfigs covered by this documentation are those for version 19.1.

### Version 19.1 (for Intel 2019b)

* Compiled our own ARPACK-ng and ELSI modules to include with DFTB+. This required
  some additional variables that should be defined when calling make, hence are
  put in ``buildopts``.
* Editing of the make.arch file is done with sed in the ``prebuildopts``.
* There are two EasyConfigs:
    * One without MPI support that contains all subprograms
    * One with MPI support where one subprogram is missing due to lack of MPI support.
* Some tests in the MPI module failed when using Python 3.7.4. Hence we switched back
  to Python 2.7.16.
