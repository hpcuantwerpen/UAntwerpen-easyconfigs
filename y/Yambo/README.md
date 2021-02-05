# Yambo install instructions

  * [Yambo home page](http://www.yambo-code.org/)
  * [Yambo development on GitHub](https://github.com/yambo-code/yambo)
      * [GitHub releases](https://github.com/yambo-code/yambo/releases). Note that
        there are often hidden tags on that page, even at the top, hiding newer versions.
  * The documentation is poor and outdated. Many of the features mentioned do not work
    anymore or do no exist anymore (such as the test suite), and when installing version
    4.5, the information about building Yambo was still for 4.4 and some pages even
    for earlier versions.
      * [Yambo Wiki](http://www.yambo-code.org/wiki/index.php?title=Main_Page)
      * [Yambo forum](http://www.yambo-code.org/forum/) may provide useful information
        also.
  * Some articles that may provide additional information:
      * [Many-body perturbation theory calculations using the yambo code](https://iopscience.iop.org/article/10.1088/1361-648X/ab15d0)


## General information

### Dependencies

  * [libxc](https://www.tddft.org/programs/libxc/): Yambo needs libxc.
    It however only seems to work with very old versions of libxc. It
    downloads its own libxc if it cannot find a compatible one.
    **Search for `version.*used` in `config/libxc.m4'.**

### Build process

  * Building with iotk does not make much sense if QuantumESPRESSO supports netCDF/HDF5.
    It is then better to build with netCDF and HDF5 support.
  * The Yambo build process does download its own internal dependencies during the
    build step. This can be avoided by putting the files into `lib/archive` beforehand.
    The problem is that some of those files don't seem to be the regular downloads,
    but come from elsewhere. E.g., current downloads of `libxc` don't contain the
    `configure script`; it has to be generated with `autoreconf -i`, but the Yambo
    build process assumes a file that does contain the configure script already.
  * Only in-place builds work. The Makefiles and configure script is buggy as hell
    and doesn't follow the GNU conventions at all (we checked 4.2.1 and 4.4.1).
    A proper configure script and associated Makefiles are assumed to distinguish between
    the source tree (where the `configure` script is located), the build tree (where
    `configure` is run) and the install tree. But the Yambo build process only works
    OK if all tree are the same (and there is no formal `install` target for make).
    Quite often the wrong variable is used in the Makefiles leading to various problems:
      * The Yambo build process has an option to keep object files. That option doesn't
        seem to work in a non-inplace build as it goes looking for some scripts in the
        install directory rather than where they are in the build directories. According
        to the spack package for Yambo, this bug is present since version 4.2.1 ("As of
        version 4.2.1 there are hard-coded paths that make the build process fail if the
        target prefix is not the configure directory"). It is definitely still present
        in the version 4.4.1. There is an configure option to not keep them, but that
        is pretty useless also due to other bugs.
      * A very similar bug also hits in other circumstances. When iotk is enabled, it
        tries to copy a file to the install directories rather than to the build directories.
      * Although Yambo claims to have a `make install` target it is actually not there
        (see also remarks in the spack code which confirm this).
   * `--enable-dp` has a different meaning than what one would expect. When it is set to yes,
     it effectively promotes variables that would be single precision otherwise to double precision.
   * There used to be a test suite and
     [it is still mentioned in the documentation](http://www.yambo-code.org/wiki/index.php?title=Test-suite-simple).
     However, the repo is nowhere to be found.

The conclusion can only be that Yambo can only be compiled in-place due to a very
buggy and non-standard install procedure.
Therefore a clean central install is rather difficult. One would have to build
with `--prefix` set to the build directory during the configure phase and then
copy whatever need to be copied. There is also no proper `make install` support,
and the configure process has several options that are documented but do not work
as advertised.


## EasyBuild

The most elegant solution to compile Yambo is to write a custom EasyBlock
that does an in-place compile rather than compiling on `/dev/shm` due to bugs in the
build procedure. There is however a workaround as a second `--prefix` argument
to configure will overwrite the first one.

As of September 2020, spack only supports up to 4.2.2 (version from May 2018)
and EasyBuild has given up at version 3.4.2.

We made our EasyConfig for Yambo 4.4.1 based on
[the spack recipe for Yambo](https://code.ornl.gov/m9b/spack/-/tree/develop/var/spack/repos/builtin/packages/yambo).


### Yambo 4.4.1

  * Dependencies:
      * Yambo 4.4.1 relies on libxc 2.2.3. The files it auto-downloads are different
        though from those in the standard libxc repositories (see also the build process).
        We used an externally compiled version as the Yambo build process otherwise
        failed.
      * Yambo 4.4.1 downloads etsf_io 1.0.4 if needed
      * Yambo 4.4.1 downloads iotk 1.2.2. Even though it can be disabled via configure,
        it shouldn't be disabled as due to bugs in the build process, Yambo will always
        try to compile some code that needs iotk. It doesn't make much sense though
        with modern versions of QuantumESPRESSO that use HDF5.
  * Problems
      * Only an in-place build works, so we had to add `--prefix` to `configopts`.
        Luckily it overwrites the default option added by EasyBuild.
      * There is no install target despite claims on some places. Our `files_to_copy` is
        derived form the spack recipe.
      * `etsf_io-1.0.4.tar.gz` could not be downloaded from the location indicated in the code.


### Yambo 4.5.3 on intel/2020a

  * Based on the setup of a user who reported problems with 4.4.1
  * Yambo 4.5.x still does not support a proper ``make install`` (nor a proper
    ``make help`` to get decent information about what the Makefiles support).
    In fact, giving ``--prefix`` to configure and pointing to the directory where you
    ultimately want to install the software, still causes a failure as it did before,
    so we still have to use the same trick with ``--prefix`` as in earlier versions.
  * The use of flags in configure is inconsistent and some have buggy implementations,
    see below.
  * Dependencies downloaded as much as possible by Yambo to let Yambo configure them
      * Exception: FFTW as that needs a patch to compile with Intel.
      * We did chech the checsum of unzipped tar files with those that we downloaded
        manually, and all were different. It is not clear if the Yambo authors made any
        significant changes or if they simple generated their own tar files from a clone
        repository which may have, e.g., one file different.
      * We did extract the URLs for the dependencies from `lib/archive/package.list`
        to download them by EasyBuild and put them in `lib/archive` to ensure that
        we can reproduce the install at a later date, even if those links may be dead
        by then.
  * --disable-iotk still does not work. Neither does --enable-etsf-io.
      * Contact with the author: ETSF-IO is not used anymore in practice and should
        be removed in a future version.
  * We did try to expand all options that the user did not specify to their default
    options just to make it as reproducible as possible to later versions which may
    have different defaults.
  * We need to unset a number of variables the EasyBuild sets. The most crucial one
    is ``CPPFLAGS``. If that is set, it may be the trigger for very strange compile
    problems in some routines such as those in ``lib/qe_pseudo`` with compilation failing
    with an error message about a separator in the Makefile. See the issue below.


| Option                     | Value                            | Where?
|----------------------------|----------------------------------|----------------------|
| --enable-keep-objects      | no (yes needed for debug only)   | yambo_specific.m4    |
| --enable-keep-src          | no (default)                     | yambo_specific.m4    |
| --enable-keep-extlibs      | yes (default)                    | yambo_specific.m4    |
| --enable-dp                | no (default) BUG                 | yambo_specific.m4    |
| --enable-time-profile      | yes (user+default)               | yambo_specific.m4    |
| --enable-memory-profile    | yes (user)                       | yambo_specific.m4    |
| --enable-uspp              | no (default)                     | yambo_specific.m4    |
| --enable-msgs-comps        | yes (user, default is no)        | yambo_specific.m4    |
| --enable-options-check     | yes (default)                    | configure.ac         |
| --enable-debug-flags       | no (default)                     | acx_fortran_flags.m4 |
| --enable-open-mp           | no (default)                     | configure.ac         |
| --enable-mpi               | yes (default+user)               | configure.ac         |
| --enable-int-linalg        | no (default)                     | blas.m4              |
| --enable-openmp-int-linalg | no (default)                     | blas.m4              |
| --enable-internal-fftqe    | no (default)                     | fft.m4               |
| --enable-internal-fftsg    | no (default)                     | fft.m4               |
| --enable-3d-fft            | depends on FFT implementation    | fft.m4               |
| --enable-slepc-linalg      | yes (as we want PETSc and SLEPc) | petsc_slepc.m4       |
| --enable-par-linalg        | no (default)                     | scalapack.m4         |
| --enable-netcdf-classic    | no (default)                     | netcdf_f90.m4        |
| --enable-netcdf-hdf5       | no (default)                     | netcdf_f90.m4        |
| --enable-hdf5-comnpression | no (default)                     | netcdf_f90.m4        |
| --enable-hdf5-par-io       | no (default)                     | netcdf_f90.m4        |
| --enable-hdf5-p2y-support  | no (default)                     | netcdf_f90.m4        |
| --enable-iotk              | yes (default)                    | iotk.m4              |
| --enable-etsf-io           | no (default)                     | etsf_io.m4           |
| --disable-cuda             |                                  | cuda.m4              |
| --disable-nvtx             |                                  | cuda.m4              |


#### Binaries generated

Executables in the ``bin`` directory:

  * Yambo interfaces:
      * ``a2y``: Always part of the interfaces
      * ``e2y``: Only when etsf-io support is turned on
      * ``p2y``: Only when IOTK is enabled, additional features depending on the HDF5
        configuration (``--enable-hdf5-p2y-support`).
  * Core of Yambo consists of:
      * ``yambo``
      * ``ypp``
      * The Yambo interfaces
  * The main Makefile suggests 4 Yambo projects:
      * PH:
          * ''yambo_ph''
          * ''ypp_ph''
      * RT:
          * ''yambo_rt''
          * ''ypp_rt''
      * NL:
          * ''yambo_nl''
          * ''ypp_nl''
      * KERR:
          * ''yambo_kerr''

Building:

  * ``make ext-libs``: Build the libraries that need to be downloaded from external
    sources.
      * The netCDF Fortran build has problems with a parallel build.
  * ``make int-libs``:
      * Builds the external libraries if not yet build
      * Build the internal libraries (``qe_pseudo``, ``slatec``,
        ``math77``, ``local`)
  * ``make yambo``:
      * Builds the internal and external libraries if not yet build
      * Builds ``yambo``.
  * ``make ypp``:
      * Builds the internal and external libraries if not yet build
      * Builds ``ypp``
  * ``make a2y`` (if relevant)
      * Builds the internal and external libraries if not yet build
      * Builds ``a2y``
  * ``make p2y`` (if relevant)
      * Builds the internal and external libraries if not yet build
      * Builds ``p2y``
  * ``make e2y`` (if relevant)
      * Builds the internal and external libraries if not yet build
      * Builds ``e2y``
  * ``make yambo_ph``
      * Builds the internal and external libraries if not yet build
      * Builds ``yambo_ph``
  * ``make ypp_ph``
      * Builds the internal and external libraries if not yet build
      * Builds ``ypp_ph``
  * ``make yambo_rt``
      * Builds the internal and external libraries if not yet build
      * Builds ``yambo_rt``
  * ``make ypp_rt``
      * Builds the internal and external libraries if not yet build
      * Builds ``ypp_rt``
  * ``make yambo_nl``
      * Builds the internal and external libraries if not yet build
      * Builds ``yambo_nl``
  * ``make ypp_nl``
      * Builds the internal and external libraries if not yet build
      * Builds ``ypp_nl`
  * ``make yambo_kerr``
      * Builds the internal and external libraries if not yet build
      * Builds ``yambo_kerr``


Single-target builds:

  * ``make libs`` is equivalent to ``make ext-libs int-libs``
  * ``make core`` is equivalent to ``make ext-libs int-libs yambo ypp a2y p2y e2y``,
    but leaving out the interfaces that are irrelevant.
  * ``make interfaces`` is a shortcut to build ``a2y``, ``p2y`` and ``e2y`` in that
    order.
  * ``make ph_project`` is equivalent to ``make ext-libs int-libs yambo_ph ypp_ph``
  * ``make rt_project`` is equivalent to ``make ext-libs int-libs yambo_rt ypp_rt``
  * ``make nl_project`` is equivalent to ``make ext-libs int-libs yambo_nl ypp_nl``
  * ``make kerr_project`` is equivalent to ``make ext-libs int-libs yambo_kerr``
  * ``make all`` is equivalent to ``make ext-libs int-libs yambo ypp a2y p2y e2y yambo_ph
    ypp_ph yambo_rt ypp_rt yambo_nl ypp_nl yambo_kerr``

#### Issue with separators in some Makefiles

The build process for some of the included libraries such as qe_pseudo can fail with
an error message about a separator in the Makefile. These Makefiles are generated
by the ``sbin/make_makefile.sh``-script and use hidden ``.objects``-files in the
library directories.

The root of the problem is that ``make_makefile,sh`` processes those files using
``cpp`` and relies on the traditional, pre-C99-behaviour when dealing with lines
in ``.objects`` that end with a backslash (to denote continuation lines).
If the ``-traditional``-flag is missing, ``.objects`` can be expanded into something
that is not legal in a Makefile as the backslashes are removed while the lines
are not joined together.

The crucial block of code is
```bash
cp $cdir/$ofile $cdir/$ofile.c
$cpp $cppflags $dopts -D_$os -D_$target $cdir/$ofile.c >> $cdir/Makefile
rm -f $cdir/$ofile.c
```
in ``make_makefile.sh.in`` (and after running ``configure`` in ``make_makefile.sh`).
If the environment variable CPPFLAGS is set when calling ``configure``, ``$cpp``
contains ``cpp $CPPFLAGS`` (with ``$CPPFLAGS`` actually expanded) instead of
``cpp -traditional``.

There are two possible solutions
  * Unset CPPFLAGS in ``preconfigopts`` in EasyBuild if the options are not
    really needed (and they are not needed when using the Intel toolchain).
  * Patch ``make_makefile.sh.in`` to use ``$cpp -traditional`` in that line
    or maybe even simply ``cpp -traditional``.
Note that configure script will actually select the ``cpp`` from GCCcore
when using the Intel toolchain.


#### Bug 1: --prefix in configure

The standard configure flag ``--prefix`` which is used to ensure that a ``make install``
at the end installs the code in the proper directory, doesn't work as it should.
In fact, not only is a working ``make install`` missing, but pointing ``--prefix``
to anything else as the build directory causes a failure during the build as the
code goes looking for include files in the wrong directories.


#### Bug 2: --enable-dp processing

According to the help information of configure, ``--enable-dp=no`` should be equivalent to
``--disable-dp``, or, given that the default is to configure for single precision, not
specifying this option. This however does not work and is a bug in the option handling
for ``--enable-dp``, where only action is taken if nothing is specified or if the value
is yes, leaving the variable ``build_precision` uninitialized (and causing the build of PETSc
to fail). The actual bug is in ``config/yambo_specific.m4``.

| Option          | enableval | enable_dp | def_dp    | build_precision |
|-----------------|-----------|-----------|-----------|-----------------|
| --enable-dp     | yes       | yes       | -D_DOUBLE | double          |
| --disable-dp    | no        | no        |           |                 |
| --enable-dp=yes | yes       | yes       | -D_DOUBLE | double          |
| --enable-dp=no  | no        | no        |           |                 |
| /               |           |           |           | single          |

``build_precision`` is actually left uninitialized when ``--disable-dp`` or ``--enable-dp=no``
is given.

Solution: in ``config/yambo_specific.m4`` (or directly in configure if you don't want
to regenerate):
```bash
def_dp=""
if test x"$enable_dp" = "x";    then enable_dp="no";     build_precision="single"; fi
if test x"$enable_dp" = "xyes"; then def_dp="-D_DOUBLE"; build_precision="double"; fi
```
should become, e.g.,
```bash
if test x"$enable_dp" = "x";    then enable_dp="no"; fi
def_dp=""
build_precision="single"
if test x"$enable_dp" = "xyes"; then def_dp="-D_DOUBLE"; build_precision="double"; fi
```
(and the first line is only needed if you want to ensure that ``enable_dp`` is not
empty which may help avoiding trouble further down the configure script.)
This would be robust even if the user made a typo (e.g., specifying ``--enable-dp=ja`),
but no error message would be shown.

Even safer would be:
```bash
if   test x"$enable_dp" = "x";    then enable_dp="no"; fi
if   test x"$enable_dp" = "xno";  then def_dp=""; build_precision="single";
elif test x"$enable_dp" = "xyes"; then def_dp="-D_DOUBLE"; build_precision="double";
else
  AC_MSG_ERROR([Illegal value for --enable-dp])
fi
```

There are many more cases where the code in the configure script could be made more
robust in this way, though it doesn't seem to be common practice to do so.

SUBMITTED AS [ISSUE #31](https://github.com/yambo-code/yambo/issues/31)


#### Bug 3: --disable-iotk does not work

When disabling IOTK, compilation fails in ``lib/qe_pseudo/read_upf_v2.f90``
as it still tries to call IOTK functions.

SUBMITTED AS [ISSUE #30](https://github.com/yambo-code/yambo/issues/30).


#### Bug 4: --enable-etsf-io does not work if no library is given with the --with-options

The build process fails to download the etsf-io package. TThe cause is a download failure, leaving an empty file.

The download is done by the Makefile in ``lib/archive``. On our system, this executes
the command
```bash
wget --no-check-certificate -O etsf_io-1.0.4.tar.gz https://github.com/yambo-code/yambo/files/845218/
```
This is not what is intended, and the cause is a typo in package.list. Line 56 should
read
```bash
url_etsf_io=https://github.com/yambo-code/yambo/files/845218/$(tarball_etsf_io)
```
(the ``_io`` at the end is missing).

SUBMITTED AS [ISSUE #29](https://github.com/yambo-code/yambo/issues/29).

#### Bug 5: The versions of PETSc and SLEPc that are being used are so old they still requires Python 2

The versions of PETSc and SLEPc that are included in Yambo 4.5.3 still require that ``python``
points to a Python 2 interpreter. As Python 2 is no longer maintained, more and more
operating systems default to Python 3 so Yambo fails to configure PETSc.

Workaround: Modify ``Makefile.loc`` to call ``python2 ./configure ...`` rather then
simply ``./configure ...``. It is definitely easier for system manager to make sure
that there is still a Python 2 on their systems that can be called as ``python2``
then to change the default ``python`` back to Python 2 just to compile Yambo.

A better solution would be to use a more recent version of PETSc and SLEPc as they
support both Python 2.7 and 3.4+.

UPDATE: This appears to be fixed in the (as of writing) upcoming version 5.0, where
much more recent versions of PETSc and SLEPc are used.


#### Bug 6: Processing of --enable-keep-src

Not exactly a bug, but there is something strange in ``config/yambo_specific.m4``:
```bash
if test x"$enable_keep_src" = "x";    then enable_keep_src="no" ; fi
if test x"$enable_keep_src" = "xyes"; then enable_keep_src="yes"; fi
```
What is the point of the second line? If ``enable_keep_src`` is ``yes`` we set it
again to ``yes``?


#### Bug 7: Inconsistent handling of ``--with-*-libs``-options and corresponding ``--enable-*`` options

In some cases, ``--with-*-libs=no`` will disable that feature, while in most cases
it is assumed that that option if specified refers to a set of options for the link
line and should not be either ``yes`` or ``no``.

  * The problem is that ``--with-petsc-libs`` and ``--with-slepc-libs`` are given a double
    meaning that way and function also as ``--with-petsc`` and ``--with-slepc``. They
    can overwrite the effect of ``--enable-slepc-linalg``.
  * ``--enable-par-linalg`` does not just enable BLACS and ScaLAPACK but enforces
    internally compiled ones. So you should omit the flag or set it to no if you want
    to use an external BLACS/ScaLAPACK which is very confusing.
  * Other ``--enable-*`` flags work a bit more as expected though it looks like a value
    of ``no`` can be overwritten by ``--with-*-libs`` and similar options, which may
    not be a good idea.

Another thing that is not taken into account is that on some supercomputers (or workstations
set up the same way) there are environment variables that point to the libraries and
the include files so that compilers may find them without `-L`` and ``-I``-options,
which is why ``--enable-<feature>`` or ``--with-<feature>`` flags make sense.

#### Bug 8: Build process of libxc

The build process does not support a parallel make due to errors in the dependencies.
So sometimes the compiler tries to open a module file that is not yet generated.

#### Missing information

  * BLAS:
      * In which order are BLAS libraries searched for?
          * First those given with the with-options?
          * Then there is a list of predefined libraries that is searched for (MKL is
            not one of them, the list is very outdated, several of those libraries
            do not exist anymore)
          * This can always be overwritten with --enable-int-linalg?
          * --enable-openmp-int-linalg does not automatically do --enable-int-linalg?
      * When are single-threaded BLAS libraries preferred and when should we use
        multithreaded ones?
  * FFT: When to use which flag? When is which FFT library preferred? Or can we use
    multiple at ones? A decision tree would be nice to have.
      * Which FFTW interfaces are used if available?
      * Can MKL be used for FFTW, and if so, how? `config/fft.m4` clearly does something
        with it.
      * It looks like configure first tries to find a FFTW-compatible library specified
        through the -with-options and then goes on trying other FFT libraries.
      * When can we use --enable-3d-fft and when can we not? And the default value is
        very unclear. It seems to be enabled by default when using the FFT from ESSL.
        It also seems to be enabled by default if the internal FFT QE (which is also
        FFTW2) is used. It doesn't seem to be used with the internal FFT SG.
      * FFT QE takes precedence over FFT SG and any FFTW-compatible library found if
        specified.
      * FFT SG takes precedense over any FFTW-compatible library found if specified.
  * The whole story of --enable-slepc-linalg, --with-petsc-libs and --with-slepc-libs
    is also downright confusing as these options have effect onto each other. Does it make
    sense to use PETSc without SLEPc? And --with-petsc-libs=no undoes some of the effect
    of --enable-slepc-linalg.
      * Are there cases where SLEPc makes sense without PETSc? It doesn't seem so.
      * Does it make sense to use PETSc without SLEPc? Likely not?
      * Do these routines make sense for a non-MPI build?
  * --enable-par-linalg is confusing. It enforces an internal BLACS and ScaLAPACK.
    And do the checks take into account that we should have a pETSc library suitably
    configured according to the requested precision? A warning should also be printed
    if the flag conflicts the MPI setting (i.e., parallel linear algebra requested
    for a non-MPI build).
  * Which configurations for an external netCDF are supported? It does need the
    netCDF Fortran interfaces. Furthermore, the following configurations can be
    generated internally:
      * netCDF without HDF5 support
      * netCDF classic, whatever that is
      * netCDF with HDF5 support
          * With or without HDF5 compression
          * With or without HDF5 parallel I/O.
  * ``--enable-iotk=no`` will be overwritten if ``--with-iotk-path`` points to a directory
    or if ``--with-iotk-path`` points to a directory or if ``--with-iotk-libs`` is
    specified and non-empty.


--enable-slepc-linalg and --enable-par-linalg are very confusing. There should be a
clear default. Moreover.
  * if slecpc_linalg is disabled, a warning should be printed that all
    ``--with-petsc-*`` and ``--with-slepc-*`` settings are neglected if any of them
    is given,
  * if slecpc_linalg is enabled is disabled, it should try to find the corresponding
    libraries using the ``--with-slepc-*`` and ``--with-petsc-*`` variables or if
    these are not given, use internal ones.
      * Moreover, it may not make sense to use an external SLEPc with an internal
        PETSc as that one may be incompatible with the external SLEPc.
  * if par_linalg is disabled, a warning should be printed that all
    ``--with-blacs-*`` and ``--with-scalapack-*`` flags will be neglected if any of
    them is given.
  * If par_linalg is enabled, the configure script should try to locate suitable
    BLACS and ScaLAPACK libraries with the help of the ``--with-blacs-*`` and
    ``--with-scalapack-*`` flags and if not revert to internal ones. And again it
    may not make sense to use an external ScaLAPACK with an internal BLACS.


