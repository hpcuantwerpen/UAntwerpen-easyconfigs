# RAxML-NG installation instructions

* [GitHub](https://github.com/amkozlov/raxml-ng)
* The authors mentioned seem to have one thing in common: They are or have been at
  HITS, the [Heidelberg Institute for Theoretical Studies](https://www.h-its.org/),
  so that is the likely source of the code.

## General information

* RAxML has a number of dependencies that have no official releases. They are not
  included in the source code if you download a tar file from the GitHub repository.
  Therefore it is better to get the sources via a recursive git clone.
* Dependencies: RAxML-NG uses the following libraries (``libs`` subdirectory)
    * [terraphast](https://github.com/amkozlov/terraphast-one) which is a clone of
      the [original terraphast Github is on the upsj account](https://github.com/upsj/terraphast-one)
      developed by Tobias Ribizel from KIT, Karlsruhe.
    * [pll-modules](https://github.com/ddarriba/pll-modules) which has a different 
      author (Diego Darriba, now at Coruña but before at HITS). It looks like this
      subproject is pretty dead at the moment.
        * pll-modules uses [libpll](https://github.com/xflouris/libpll-2) which has yet another
          author, Tomas Flouri who seems to be linked to both UCL, london and HITS. 
          The libpll code seems to be as dead as pll-modules, both saw their last 
          update in June 2017.
          Stored in the ``libs/libpll`` subdirectory of ``libs/pll-modules``.
* RAxML-NG supports distributed memory parallelisation with MPI and shared memory 
  parallelisation using pthreads. It is not clear if using both together really gives
  a hybrid executable as the documentation is mostly missing. In any case, MPI is only
  used by the RAxML-NG code itself, not by any of the dependencies (terraphast or 
  pll-modules/libpll).
* libpll has different code for SSE, AVX and AVX2, and a generic code path as an 
  alternative. 
    * The SSE, AVX and AVX2 codes use intrinsics so this may give problems
      with some compilers that don't support certain intrinsics.
    * Even if a system supports AVX2, it is best to leave the lower options
      activated also as a lower code path is sometimes used if there is no
      benefit of using a higher one.
    * All three code paths should always be activated if supported, unless 
      ``-DENABLE_SSE=false``, ``-DENABLE_AVX=false``
      and/or ``-DENABLE_AVX2=false`` are specified. Check what CMake does 
      to be sure if the right code paths are compiled into the code. 
* The main RAxML-NG code is C++. Hence the CXX-range of options matter. 
* pll-modules and libpll is C-code.
* terraphast is C++-code. Moreover, it uses some intrinsics that may be
  compiler-specific in the code in the ``lib`` subdirectory. There are some
  header files to solve portability problems, with support for GCC, Clang
  and the Microsoft compiler.
    * It does turn out that all the directives that are used in the GCC/Clang
      version are also supported by the Intel compiler since the 2018 releases.
    * This is also the component of the code that can use the GNU GMP library.

## CMake configuration as it is in the code

<table>
<tr><th>Variable</th>                <th>Default</th> <th>Meaning</th></tr>
<tr><td>RAXML_BINARY_NAME</td>       <td></td>        <td>Custom RAxML-NG binary name</td></tr>
<tr><td>USE_LIBPLL_CMAKE</td>        <td>ON</td>      <td>Use CMake to build libpll and pll-modules. Will be forced to ON when building as a library</td></tr>
<tr><td>BUILD_AS_LIBRARY</td>        <td>OFF</td>     <td>Build RAxML-NG as shared library (instead of stand-alone executable). Naming is derived from the name of the matching executable.</td></tr>
<tr><td>USE_PTHREADS</td>            <td>ON</td>      <td>Enable multi-threading support (PTHREADS)</td></tr>
<tr><td>USE_MPI</td>                 <td>OFF</td>     <td>Enable MPI support</td></tr>
<tr><td>USE_VCF</td>                 <td>OFF</td>     <td>??? No explanation available</td></tr>
<tr><td>ENABLE_PLLMOD_SIMD</td>      <td>OFF</td>     <td>Enable SIMD instructions in pll-modules (non-portable but slightly faster)</td></tr>
<tr><td>STATIC_BUILD</td>            <td>OFF</td>     <td>Build static binary (don't use with MPI!)</td></tr>
<tr><td>USE_TERRAPHAST</td>          <td>ON</td>      <td>Use phylogentic terraces library (terraphast)</td></tr>
<tr><td>USE_GMP</td>                 <td>OFF</td>     <td>Use Gnu Muliple precision (GMP) library, only relevant for terraphast</td></tr>
<tr><td></td>    <td></td>    <td></td></tr>
<tr><td>MPI_CXX_COMPILER</td>        <td></td>        <td>Used if USED_MPI is ON</td></tr>
<tr><td>MPI_CXX_COMPILER_FLAGS</td>  <td></td>        <td>Used if USE_MPI is ON</td></tr>
<tr><td>ENABLE_SSE</td>              <td>True</td>    <td>Used to enable or explicitly disable SSE3 optimizations in libpll</td></tr>
<tr><td>ENABLE_AVX</td>              <td>True</td>    <td>Used to enable or explicitly disable AVX optimizations in libpll</td></tr>
<tr><td>ENABLE_AVX2</td>             <td>True</td>    <td>Used to enable or explicitly disable AVX2 optimizations in libpll</td></tr>
<tr><td></td>    <td></td>    <td></td></tr>
<tr><td></td>    <td></td>    <td></td></tr>
<tr><td></td>    <td></td>    <td></td></tr>
</table>

* When no custom binary name is given (which is advised), the name of the binary
  depends on a number of options.
   * No MPI, no static linking: ``raxml-ng``
   * No MPI, static linking: ``raxml-ng-static``
   * MPI, no static linking: ``raxml-ng-mpi``
   * MPI with static linking is not supported??
* There are more options, e.g., ``PLLMOD_DEBUG``, that are only relevant to 
  code development and not to creating a user installation.
* It is really the implementation of ``ENABLE_RAXML_SIMD`` and ``ENABLE_PLLMOD_SIMD``
  that is problematic (at least in version 0.9.0, when this was written) as it
  currently enforces the selection between very bad and bad compiler options for
  performance on modern hardware.
* The CMAKE_C_... and CMAKE_CXX_... are used in the recipe but not taken from the
  environment or defines on the command line as they have the type ``INTERNAL``.
* From version 0.9.0 on, ``make install`` is supported to install the binaries, but
  it does not work correctly when installing RAxML-NG as a shared library as it is put in
  bin instead of in lib or lib64.

## EasyConfigs

EasyConfigs were developed at UAntwerp as there was no support for the -NG version
in EasyBuild when we started. By now there is [an official EasuBuilders
recipe for RAxML-NG](https://github.com/easybuilders/easybuild-easyconfigs/blob/develop/easybuild/easyconfigs/r/RAxML-NG/RAxML-NG-0.9.0-gompi-2019b.eb)
that however suffers from most of the problems that we indicate below.

This documentation was started when installing version 0.9.0. However, we did try to
reconstruct what we did in earlier versions and cover this in the documentation also.

The main problem with installing RAxML-NG is the poor quality of the build scripts.
They impose certain compiler options that 
  1. are only valid for GCC and
  2. are for ancient systems (Ivy Bridge and before) and suboptimal for later systems.

As the root CMake file then further calls configure scripts  


### Version 0.4.1

* This was still without terraphast.
* We needed to adapt the main CMakeList.txt file to recognize the Intel compilers.
  This was not sufficient though, libpll was still compiled in a suboptimal way
  (no ``-xHost``).
* The recipe does not do a download of the sources from GitHub, this still has to
  be done manually.


## Version 0.8.1

* This version now comes with with terraphast which we didn't get to compile with 
  the Intel compiler. Since we didn't have a full FOSS toolchain with working MPI 
  set up at the time, we did not build a distributed memory version.
* We made similar changes to the main CMakeLists.txt file. We now had to stick to
  the GCC compilers though. Which also were used in a suboptimal way for the 
  dependencies. We tried to add the Intel compiler to the recognized compilers,
  and additional options for the SIMD settings chosing better compiler options.


### Version 0.9.0

* Rather than using the system of the EasyBuilders recipe of downloading
  4 files, 3 of them based on commits that have to be looked up first, we
  use EasyBuild's feature to use a recursive download of a tag on the GitHub
  and assemble the download file that way. This saves us from looking up
  that commits that are needed for the dependencies every time we install
  a new version.
* Added GMP which turned out to be useless in the original code as the
  support in a subproject was turned off, see below.
* The CMake configuration now supports "make install" so we now use that to
  install the software.
* Using the default CMakeLists.txt file: Compiled with GCCcore for Hopper 
  (Ivybridge architecture) as this is the only machine for which the compiler
  flags are somewhat reasonable. This still implies that the terraphast component
  is compiled without any optimizations, just the default generic architecture
  -O0 of GCC due to bugs in the configuration procedure.
* We made a lot of fixes to the whole CMake configuration process (see the
  subsections below). We ended up with the following configuration:
   * Ensure that the compiler options are picked up from EasyBuild and that
     the defaults from CMake are fully surpressed by setting ``ENFORCE_COMPILER_FLAGS``
     to OFF and initializing all CMAKE_C*_FLAGS_* (some are already done 
     automatically by EasyBuild).
   * Turn on SIMD optimizations for pll-modules (in fact, for libpll), but 
     setting the specific optimization options in SSE_FLAGS, AVX_FLAGS
     and AVX2_FLAGS off as they should already be covered by the 
     options to optimize for a specific architecture chosen by EasyBuild
     (and if they are not, that level of SIMD is not supported anyway
     by the architecture).
   * We turn on terraphast and compile it with GMP support.
   * Threading support is also turned on, also in the MPI version.
   * There is something we cannot explain yet: libpll did compile on Hopper
     (Ivybridge) using only -xHost and no AVX2-specific option. CMake did not
     detect that there was no AVX2 and the code also compiled without problems.
     So it looks like what is called AVX2 might not be AVX2? OR what happened to
     the intrinsics, becasue they do look like AVX2 intrinsics...

#### Remarks on the configuration and compilation process

* ``pll-modules`` and ``libpll`` pick up compiler options that are passed through 
  the environment, but add additional ones that may not be optimal for the chosen 
  compiler or not be valid.
* ``terraphast`` looked like a complete disaster, but this was more due to
  RAxML-NG making a mess of compiler settings and configuration. 
  The main code is compiled OK now and with a few corrections to the CMakeLists.txt 
  file and a bug fix which was not yet included in the version that ships with 
  RAxML-NG, it now compiles OK with Intel also.

##### Main RAxML-NG package

* Problems with the main code configuration:
    * One problematic block is the block that starts with ``if (ENABLE_RAXML_SIMD )``
      in the ``CMakeLists.txt`` file in the root directory of RAxML-NG as it imposes
      compiler options and does so at the end, overwriting options that a knowledgeble
      user may consider more appropriate. Moreover, a compiler may have different
      options to activate AVX or SSE3 support. The variables that are defined 
      (``__SSE3`` and ``__AVX``) aren't used in the code.
    * ``CMAKE_CXX_FLAGS_DEBUG`` and several similar variables were set to type ``INTERNAL``
      rather than ``STRING``, probihibiting the user to overwrite them, which is a very
      bad idea. After all, the user may need different flags for his/her compiler.
    * Adding ``-D_RAXML_PTHREADS -pthread`` to ``CMAKE_C_FLAGS`` while compiling 
      the dependencies, does not make sense at all as that information is not used in
      those codes anyway.
    * The block that is executed when ``ENABLE_GMP`` is ``ON`` comes too early.
      Moreover, it assumes that the terraphast initialization will indeed succeed in
      locating the GMP libraries which is also not the case, especially since 
      ``TERRAPHAST_USE_GMP`` seems to be turned off in ``raxml-ng/libs/CMakeLists.txt``.
* **Modifications to ``CMakeLists.txt`` in ``raxml-ng``, the main RAxML-ng directory:**
    * Also recognize the Intel compiler.
    * Made compiler arguments that are added dependent on the compiler as not all 
      options are accepted by all compilers.
    * Made it possible for a user to overwrite all default compiler flags so that 
      it is possible to more or less adapt to other compilers, or chose better options
      for a particular architecture.
    * Removed the block that starts with ``if (ENABLE_GMP)`` as it does
      nothing useful: GMP is only used through terraphast, and when done correctly,
      no information about GMP is needed in the main project.
    * Removed the problematic block that starts with ``if (ENABLE_RAXML_SIMD )`` and\
      the option ``ENABLE_RAXML_SIMD`` as it only hurts.
    * Provide a lot more feedback to the user. It may not be important to a very 
      inexperienced user, but it does help an experienced user to check if everything
      works as intended.
* **Modifications to ``CMakeLists.txt`` in ``raxml-ng/src``:**
    * The terrace library from the terraphast subproject was included in the wrong
      way and therefore the GMP libraries were also not found when linking.
    * Non-essential modifications that provide additional output to diagnose
      what CMake is doing. It is not strictly needed to patch this file.
* **Modifications to ``CMakeLists.txt`` in ``raxml-ng/test/src``:**
    * Got rid of the GMP block as that is not needed if the terraces project
      is included in the right way (which is the case now with the patches
      to ``CMakeLists.txt`` in ``raxml-ng`).
* **Modifications to ``CMakeLists.txt`` in ``raxml-ng/libs``:**
    * USE_GMP or its processed value in ENABLE_GMP was not passed on
      to the terraphast code. This has been corrected. It was probably due
      to the author not being able to figure out how to link properly to
      the GMP library.
    * USE_THREADS or its processed value ENABLE_THREADS is not passed on 
      to the terraphast code. This has been corrected. It is not clear if
      this is due to problems with threading between the main RAxML-NG and 
      the terraphast code or not.

##### pll-modules and libpll

* pll-modules uses the compiler options passed to it in CMAKE_C_FLAGS augmented 
  with options hard-coded in PLLMOD_CFLAGS defined in its src subdirectory.
     * It does add an optimization option to this variable also, which is a
       bad idea as they belong are better set in ``CMAKE_C_FLAGS_RELEASE`` or 
       ``CMAKE_C_FLAGS`` (and is set as the options are passed earlier in the 
       hierarchy).
* libpll uses the compiler options passed to in it in CMAKE_C_FLAGS augmented 
  with options hard-coded in LIBPLL_BASE_FLAGS defined in its src subdirectory.
     * And it is not clear what it does with the ``SIMD_FLAGS`` that it builds
       beyond testing for SSE3, AVX and AVX2 support.
     * The individual SIMD flags for each type are used though when compiling 
       a file of that type. Hence it might be better to allow to replace them
       by empty options to not conflict with other target-specific options that
       may be specified.
* **Modifications to ``CMakeLists.txt`` in ``libpll/src``:**
     * Removed the optimization level from ``LIBPLL_BASE_FLAGS`` as this should
       be set in ``CMAKE_C_FLAGS_RELEASE`` or ``CMAKE_C_FLAGS`` (and is set 
       as the options are passed earlier in the hierarchy). *Note that if libpll
       is to be used as an independent component, some of the code to detect
       the C compiler and set appropriate defaults for these variables should
       probably be copied from ``raxml-ng/CMakeLists.txt`` to 
       ``libpll/CMakeLists.txt``.*
     * Allow the user to specify SSE_FLAGS, AVX_FLAGS and AVX2_FLAGS, with the
       old GNU values as the default. If the user specifies architectural compile
       options through CMAKE_C_FLAGS that support certain SIMD extensions, these
       options are not needed, not to detect if support is present and not to 
       compile the code.
* **Modifications to ``CMakeLists.txt`` in ``pll-modules``:**
     * Only non-essential modifications producing additional output to make it
       easier to follow what CMake is doing have been added to the file.
* **Modifications to ``CMakeLists.txt`` in ``pll-modules/src``:**
     * Removed the optimization option ``-O3`` from ``PLLMOD_CFLAGS`` as it is
       better to get those from ``CMAKE_C_FLAGS_RELEASE`` or ``CMAKE_C_FLAGS``.
       *Note that if pll-modules
       is to be used as an independent component, some of the code to detect
       the C compiler and set appropriate defaults for these variables should
       probably be copied from ``raxml-ng/CMakeLists.txt`` to 
       ``pll-modules/CMakeLists.txt``.*

##### terraphast

* Analysis of portability problems in the code
    * ``lib`` subdirectory: The files ``gcc-clang/intrinsics.hpp`` and
      ``cl/intrinsics.hpp`` map a number of functions to intrinsics for respectively
      GCC and Clang and the Microsoft C/C++ compiler. The GNU/Clang version uses:
        * ``__builtin_popcountll``: This intrinsic is supported in the Intel 16 (2016)
          and later compilers. We didn't check older Intel compilers. 
        * ``__builtin_ctzll`` and ``__builtin_clzll``: Supported in the Intel compilers
          version 16 (2016) and later. I didn't try older compilers.
        * ``__builtin_add_overflow``, ``__builtin_mul_overflow`` are supported since
          version 18 (2018 suite).
* The whole configuration process is organised from a single ``CMakeLists.txt`` file
  in the root ``terraphast`` directory.
* There is a double problem with the option ``TERRAPHAST_ARCH_NATIVE``:
    * The option it adds is not valid for all compilers. E.g., for the Intel compiler
      it should be ``-xHost`` (which then is bad for AMD)
    * It does not make sense to add ``-march=native`` automatically if you don't add
      other optimization options, as the default for the GNU C++ compiler is ``-O0``.
* The support for the GNU GMP library is broken. For some reason, the Makefile sees
  gmpxx and gmp as targets rather than libraries it should add when linking,
  resulting in a message from make it cannot build those targets.
    * Building libterraces.a works (-DTERRAPHAST_BUILD_CLIB=OFF -DTERRAPHAST_BUILD_APPS=OFF
      -DTERRAPHAST_BUILD_TESTS=OFF) and this is all that is needed to build RAxML-NG.
    * Building the C library also works (-DTERRAPHAST_BUILD_CLIB=ON which is the default).
    * Building the apps fails (-DTERRAPHAST_BUILD_APPS=ON which is the default)
    * Building the unit tests fails (-DTERRAPHAST_BUILD_TESTS=ON which is the default).
    * The root cause of the problems is a badly designed ``FindGMP.cmake`` block that
      lacked a crucial line, and was also not optimal in helping the user to find the 
      correct library files.
* **Modifications to ``terraphast/cmake/FindGMP.cmake``**
    * Defined a new CMake variable, ``GMP_PREFIX`` that points to the directory 
      where the include and lib or lib64 subdirectories can be found, and added
      corresponding ``PATHS`` clauses to the ``find_path`` and ``find_library`` calls. 
      This may not be optimal in Windows, but on our system for some reason CMake 
      failed to find the include files and libraries using the standard search
      directories that we have defined in our environment (``CFILES`` and ``LIBRARY_PATH``).
      It also ensures that now at the end of the function, ``GMP_LIBRARIES`` and
      ``GMPXX_LIBRARIES`` contain the full library name including the path, which 
      was needed for a correct dependency search when building the apps and test
      executables.
    * Added a crucial ``set_target_properties`` line for ``gmpxx`` that was missing.
      Without that line, linking failed.
* **Modifications to ``terraphast/CMakeLists.txt``:**
    * Changed the processing of ``TERRAPHAST_ARCH_NATIVE`` so that it now also adds
      an optimization level and produces options that as far as I know are correct
      on GCC, Clang and Intel (though the Intel option is not so good for AMD). 
      Note that a user doesn't have to set this flag to True as it is perfectly possible
      to pass suitable optimization options through ``CMAKE_CXX_FLAGS`` and
      ``CMAKE_CXX_FLAGS_RELEASE``.
      *The change is not really needed to compile RAxML-NG as we can make sure the
      options are indeed passed through other CMAKE variables and that ``TERRAPHAST_ARCH_NATIOVE``
      is turned off.*
    * (Nonessential) Additional information given when GMP is found, and some other 
      changes to messages to make clearer where the message comes from.
* **Fixes to the terraphast code**
    * Fixed an issue in ``lib/bits.hpp`` with an implicit type conversion from 
      sizt_t/uin64_t to uint8_t: 
      ``inline uint8_t shift_index(index i) { return i % word_bits; }``
      should be replaced with
      ``inline uint8_t shift_index(index i) { return (uint8_t) (i % word_bits); }``
    * Even with the fix we already have, there are still issues with verbose_run      


#### CMake configuration after our patches

<table>
<tr><th>Variable</th>                <th>Default</th>            <th>Meaning</th></tr>
<tr><td>RAXML_BINARY_NAME</td>       <td></td>                   <td>Custom RAxML-NG binary name</td></tr>
<tr><td>USE_LIBPLL_CMAKE</td>        <td>ON</td>                 <td>Use CMake to build libpll and pll-modules. Will be forced to ON when building as a library</td></tr>
<tr><td>BUILD_AS_LIBRARY</td>        <td>OFF</td>                <td>Build RAxML-NG as shared library (instead of stand-alone executable). Naming is derived from the name of the matching executable.</td></tr>
<tr><td>USE_PTHREADS</td>            <td>ON</td>                 <td>Enable multi-threading support (PTHREADS)</td></tr>
<tr><td>USE_MPI</td>                 <td>OFF</td>                <td>Enable MPI support</td></tr>
<tr><td>USE_VCF</td>                 <td>OFF</td>                <td>??? No explanation available</td></tr>
<tr><td>ENABLE_PLLMOD_SIMD</td>      <td>OFF</td>                <td>Enable SIMD instructions in pll-modules (non-portable but slightly faster)</td></tr>
<tr><td>STATIC_BUILD</td>            <td>OFF</td>                <td>Build static binary (don't use with MPI!)</td></tr>
<tr><td>USE_TERRAPHAST</td>          <td>ON</td>                 <td>Use phylogentic terraces library (terraphast)</td></tr>
<tr><td>USE_GMP</td>                 <td>OFF</td>                <td>Use Gnu Muliple precision (GMP) library, only relevant for terraphast</td></tr>
<tr><td>CMAKE_C_FLAGS</td>           <td>""</td>                 <td></td></tr>
<tr><td>CMAKE_C_FLAGS_RELEASE</td>   <td>compiler-dependent</td> <td></td></tr>
<tr><td>CMAKE_C_FLAGS_DEBUG</td>     <td>-O0 -g</td>             <td></td></tr>
<tr><td>CMAKE_CXX_FLAGS</td>         <td>""</td>                 <td>Also used for MPI.</td></tr>
<tr><td>CMAKE_CXX_FLAGS_RELEASE</td> <td>compiler-dependent</td> <td></td></tr>
<tr><td>CMAKE_CXX_FLAGS_DEBUG</td>   <td>-O0 -g</td>             <td></td></tr>
<tr><td>MPI_CXX_COMPILER</td>        <td></td>                   <td>Used if USED_MPI is ON</td></tr>
<tr><td>MPI_CXX_COMPILER_FLAGS</td>  <td></td>                   <td>Used if USE_MPI is ON</td></tr>
<tr><td>ENABLE_SSE</td>              <td>True</td>               <td>Used to enable or explicitly disable SSE3 optimizations in libpll</td></tr>
<tr><td>ENABLE_AVX</td>              <td>True</td>               <td>Used to enable or explicitly disable AVX optimizations in libpll</td></tr>
<tr><td>ENABLE_AVX2</td>             <td>True</td>               <td>Used to enable or explicitly disable AVX2 optimizations in libpll</td></tr>
<tr><td>SSE_FLAGS</td>               <td>"-msse3"</td>           <td>Added to the compiler options by libpll for SSE3-specific files.</td></tr>
<tr><td>AVX_FLAGS</td>               <td>"-mavx"</td>            <td>Added to the compiler options by libpll for AVX-specific files.</td></tr>
<tr><td>AVX2_FLAGS</td>              <td>"-mfma -mavx2"</td>     <td>Added to the compiler options by libpll for AVX2-specific files.</td></tr>
<tr><td>ENFORCE_COMPILER_FLAGS</td>  <td>ON</td>                 <td>Enforce hard-coded compiler options for CMAKEX*_FLAGS_* in the RAxML-NG configuration files rather than the CMake defaults or user-specified ones.</td></tr>
</table>
