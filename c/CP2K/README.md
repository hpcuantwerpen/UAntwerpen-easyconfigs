# CP2K installation instructions

* [CP2K web site](https://www.cp2k.org/)
    * [How to compile the CP2K code](https://www.cp2k.org/howto:compile)
* [CP2K GitHub](https://github.com/cp2k/cp2k)
* CP2K compiler support:
    * [Page on CP2K.org](https://www.cp2k.org/dev:compiler_support)
    * [CP2K dashboard](https://dashboard.cp2k.org/)
* [CP2K Google forum](https://groups.google.com/forum/#!forum/cp2k)

## General installation instructions

Part of the procedure is based on contact with one of the CP2K authors.

CP2K uses Libint
* Versions up to 6.1 only support the currently deprecated Libint 1.1.x interfaces
* Versions from 7.1 onwards support Libint 2.x
* Libint should be statically linked
* ``max-am`` (angular momentum) values: libint will generate code to calculate potentials 
  up to a given angular momentum value.  You pass the maximum angular momentum values 
  during libint's configure phase, e.g.
  ``./configure --with-libint-max-am=5 --with-libderiv-max-am1=4 ...``
  CP2K cannot detect the values used, you have to set the correct compilation options yourself,
  using the values from libint's configure, and adding 1, e.g.,
  ``-D__LIBINT_MAX_AM=6  -D__LIBDERIV_MAX_AM1=5``
    
CP2K comes with a default library of potentials and wavefunction basis sets
(data directory in the source archive). The location of this library is compiled
into the code using the define
``-D__DATA_DIR=.../data``
(by default, the location in the source tree at compile-time is used), and can be
overridden at runtime using the environment variable ``CP2K_DATA_DIR``.
If no data dir is found, CP2K fails.

The configuration of CP2K is based on editing a suitable architecture script that is
included by the main Makefile. They are stored in the ``arch`` subdirectory and
passed to the code through the ``ARCH`` variable given when calling ``make``.

Be careful calling a version "hybrid" as a CP2K option will not think of a 
hybrid MPI/OpenMP executable but "hybrid functionals". So avoid confusion!

CP2K contains a script to install a number of its dependencies 
(``tools/toolchain/install_cp2k_toolchain.sh``). The actual installation
is done via scripts for individual packages stored in 
``tools/toolchain/scripts`` 
([link to GitHub master branch](https://github.com/cp2k/cp2k/tree/master/tools/toolchain/scripts)).

## CP2K EasyConfigs

There is an EasyBlock for CP2K. Since we've experienced problems with it,
we use the MekeCp generic EasyBlock instead as this allows full control over
the installation.

### Version 7.0 commit 44b70af5 (pre-release of version 7.1)

* [GitHub](https://github.com/cp2k/cp2k/tree/31ce44dbd3bfa7bf5ad1bc85906630d9ce148c5d)
     * [Scripts for dependencies](https://github.com/cp2k/cp2k/tree/31ce44dbd3bfa7bf5ad1bc85906630d9ce148c5d/tools/toolchain/scripts)
* This commit still uses Libint 1.x
* The EasyConfig uses the versions of Libint, libxc, PLUMED, libxsmm and ELPA that
  would be downloaded by the code (the "toolchain" script that can download and
  install those dependencies).
* The EasyConfig with PLUMED support (version 2.4.1) only includes the popt and psmp
  executables as PLUMED requires the MPI symbols. 
  On our systems it passed all tests (using update 3 of the Intel 2018 
  compilers) except ``tests/QS/regtest-rel/Hg_rel.inp`` which fails for the
  psmp executable on Ivybridge CPUs.
* The EasyConfig without PLUMED support includes the sopt, ssmp, popt and psmp
  executables. 
  It passes all tests except ``tests/QMMM/QS/regtest-4/acn-conn-1.inp`` which fails
  for the ssmp executable.

Suggested dependencies:
<table>
  <tr><th>Package</th><th>Version suggested</th><th>Version used</th></tr>
  <tr><td>ELPA</td>   <td>2017.05.003</td>  <td>2017.05.003</td></tr>
  <tr><td>Libint</td> <td>1.1.6</td>        <td>1.1.6</td></tr>
  <tr><td>libxc</td>  <td>4.3.4</td>        <td>4.3.4</td></tr>
  <tr><td>libxsmm</td><td>1.10.0</td>       <td>1.10.0</td></tr>
  <tr><td>PLUMED</td> <td>No suggestion</td><td>2.4.1</td></tr>
  <tr><td>GSL</td>    <td>2.5</td>          <td>2.5</td></tr>
<table>


### Version 7.0 commit 31ce44db (pre-release of version 7.1)

* [GitHub](https://github.com/cp2k/cp2k/tree/44b70af5aa9628cb07451649d52548a7bc5d8de1)
     * [Scripts for dependencies](https://github.com/cp2k/cp2k/tree/44b70af5aa9628cb07451649d52548a7bc5d8de1/tools/toolchain/scripts)
* This commit already uses Libint 2.x. Note that we use a version of Libint
  specifically packaged and configured for CP2K.
* Only a version without PLUMED was tested.
* There was a patch needed to hardcode the revision in the Makefile as automatic
  detection does not work when used with EasyBuild. EasyBuild does not store
  the ``.git`` directory which is used to recover that information in this
  commit. Note that this changed again in later revisions.

Suggested dependencies:
<table>
  <tr><th>Package</th><th>Version suggested</th><th>Version used</th></tr>
  <tr><td>ELPA</td>   <td>2019.05.001</td>  <td>2019.05.002</td></tr>
  <tr><td>Libint</td> <td>2.6.0</td>        <td>2.6.0</td></tr>
  <tr><td>libxc</td>  <td>4.3.4</td>        <td>4.3.4</td></tr>
  <tr><td>libxsmm</td><td>1.14</td>         <td>1.14</td></tr>
<table>


### Version 7.1

* [GitHub](https://github.com/cp2k/cp2k/tree/support/v7.1)
     * [Scripts for dependencies](https://github.com/cp2k/cp2k/tree/support/v7.1/tools/toolchain/scripts)
* Only trivial changes were needed compared to the EasyConfigs for the prerelease versions 
  except for support of PLUMED 2.5+.
* The installation of PLUMED 2.5+ does no longer include the large list of object files 
  for statically linking with PLUMED. We've tried to engineer what the ``install_plumed.sh``
  adds to the linker options and made a new patch file. 
* Note that there are still various options that are not included, e.g., support for 
  PEXSI, QUIP, spglib, SIRIUS and FPGA. It is also not always clear which extensions 
  work with which versions of CP2K.

Suggested dependencies:
<table>
  <tr><th>Package</th><th>Version suggested</th><th>Version used</th></tr>
  <tr><td>ELPA</td>   <td>2019.05.001</td>  <td>2019.05.002</td></tr>
  <tr><td>Libint</td> <td>2.6.0</td>        <td>2.6.0</td></tr>
  <tr><td>libxc</td>  <td>4.3.4</td>        <td>4.3.4</td></tr>
  <tr><td>libxsmm</td><td>1.14</td>         <td>1.14 in 2019b, 1.15 in 2020a</td></tr>
  <tr><td>PLUMED</td> <td>2.5.2</td>        <td>2.5.4</td></tr>
  <tr><td>GSL</td>    <td>2.5</td>          <td>2.5</td></tr>
<table>

We tested PLUMED 2.6.0 also (with similar test results as 2.5.4)
but sticked to the 2.5 branch which is the one that is 
officially supported by CP2K version 7.1. We also tested compiling with the older
version 2.4.7 of PLUMED, which still worked in the old way with statically linking
to a list of object files (different patch included).


### Version 9.1

* [GitHub](https://github.com/cp2k/cp2k/tree/support/v9.1)
     * [Scripts for dependencies](https://github.com/cp2k/cp2k/tree/support/v9.1/tools/toolchain/scripts)
* Only trivial changes were needed compared to the EasyConfigs for the previoius versions.
* Support for PLUMED 2.7.3 included.

Suggested dependencies:
<table>
  <tr><th>Package</th><th>Version suggested</th><th>Version used</th></tr>
  <tr><td>ELPA</td>   <td>2021.11.001</td>  <td>2021.11.002</td></tr>
  <tr><td>Libint</td> <td>2.6.0</td>        <td>2.6.0</td></tr>
  <tr><td>libxc</td>  <td>5.1.7</td>        <td>5.1.7</td></tr>
  <tr><td>libxsmm</td><td>1.17</td>         <td>1.17</td></tr>
  <tr><td>PLUMED</td> <td>2.7.3</td>        <td>2.7.3</td></tr>
<table>
