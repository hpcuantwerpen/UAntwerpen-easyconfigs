# DFTB+ installation instructions

* [DFTB+ web site](https://www.dftbplus.org/)
* [DFTB+ GitHub](https://github.com/dftbplus/dftbplus)
* Dependencies
    * The usual linear algebra stuff: BLAS/LAPACK/ScaLAPACK
    * Python (at least 2.6) with NumPy is needed for the tests. 
    * Optional: [ELSI library](https://wordpress.elsi-interchange.org/).
      Testing shows that ELSI should be compiled with support for 
      [PEXSI](https://pexsi.readthedocs.io/en/latest/).
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

* Compiled our own ARPACK-ng module to include with DFTB+. This required
  some additional variables that should be defined when calling make, hence are
  put in ``buildopts``.
* Editing of the make.arch file is done with sed in the ``prebuildopts``.
* There are two EasyConfigs:
    * One without MPI support that contains all subprograms
    * One with MPI support where one subprogram is missing due to lack of MPI support.
      It also lacks the ELSI support.
* Some tests in the MPI module failed when using Python 3.7.4. Hence we switched back
  to Python 2.7.16.


### TODO

* Try to implement support for ELSI (introduced in 19.1?). There are a number of difficulties however:
    * There might be a name conflict for the internal symbols. Depending on whether
      -standard-semantics or or -assume [no]std_mod_proc_name is used, the symbols 
      for module functions are composed from the lowercase module name and function
      name using either _MP_ or _mp_ as separater between the two. The former is the
      better behaviour (as it avoids naming conflict with functions that may have
      _mp_ in their name) while the latter is the default behaviour of the Intel compiler.
      I got link problems with ELSI als ELSI used the latter while the DFTB+ arch file
      used options that triggered the first.
    * It actually expects an ELSI with PEXSI support compiled into it
    * If you compile with ELSI support you have to make sure that ELSIINCDIR is defined
      in ``make.arch``. Otherwise an empty ``-I`` argument is generated when compiling
      dftp+ which leads to problems in the MPI version as the compiler misinterprets
      the remaining -I arguments and can't find its module files. Similarly ELSIDIR 
      should point to the directory containing the libraries to avoid an empty ``-L``
      argument.
        * Remaining problem: Difference in symbols in the ELSI library between what is
          in the library (names containing _mp_ for the MPI versions) and what DFTB+
          expects (names with _MP_). It is not yet clear what causes this or who is
          at fault.
    * Note that ELSI will only be fully enabled when compiling with MPI support.
