# KITE aka Quantum-KITE installation

  * [KITE web site](https://quantum-kite.com/)
      * [Installation instructions](https://quantum-kite.com/installation/), however
        they only function with GCC and not on our clusters.
  * [KITE GitHub repository](https://github.com/quantum-kite/kite)

## General information

  * The documentation talks about version 1.0, but there is no such tag in the GitHub
    repository. Hence we work from a commit.
  * KITE needs C++11 and one of the components needs C++17.
  * KITE has a CMake build process but it is broken in many ways (early 2021):
      * It only supports the GNU C++ compiler and several CMAKE variables are hard
        set that shouldn't be hard set.
      * There is no procedure to build everything in a single
        ``cmake``-``make``-``make install`` cycle. The KITEx executable needs
        to be build from the ``CMakeLists.txt`` in the kite root directory while the ``KITE-tools``
        executable needs to be build from the ``CMakeLists.txt`` in the tools subdirectory,
        so effectively using two build directories.
      * This last bullet makes it a lot harder to integrate properly with the software
        that HPC centres use to manage their software stack such as EasyBuild or Spack.
  * In early 2021, there is an old build script in the KITE directory: ``compile_Script.sh``
    which again is GNU only and broken in many ways.
      * Some of the source files needed for ``KITE-tools`` are not included.
      * There is no way to configure the location of tools that are needed etc.
        It is really the kind of script that only works on the system of the developer.

### Specific install problems

  * Compiling with the Intel compilers works but is hard, and there are several problems
    on the way
      * Linking fails when compiling with an optimization level higher than ``-O0``
        without inter-procedural optimisations. The easy solution is to add ``-ipo``
        to the compile and link command lines.
      * Adapting the ``CMakeLists.txt`` files seems to be non-trivial (see also below).
        Simply deleting the lines that reset the compilers to the GNU compilers is
        and ensuring that the right compiler flags are used via ``-DCMAKE_...`` definitions
        when calling ``cmake`` turned out not to be enough. We still observed link
        problems for ``KITE-tools``. It is not clear if this is due to the way CMake
        links the HDF5 libraries (with rpath) or not.
  * The list of minor and major issues with the ``CMakeLists.txt`` files in the root
    directory and the ``tools`` subdirectory is extensive.
      * At the top, ``CMAKE_C_COMPILER`` and ``CMAKE_CXX_COMPILER`` are redefined
        to be ``gcc`` and ``g++`` respectively. Redefining those variables is a very
        bad idea... **We removed those lines when using cmake.**
      * Setting ``CMAKE_CXX_STANDARD`` to ``17`` choses the wrong option for the Intel
        compiler. **We removed those lines and selected the C++-standard via
        ``CMAKE_CXX_FLAGS``.**
      * The messages printed during the HDF5 detection are wrong (the message for Hdf5 shows
        the information for Hdf5hl and vice-versa).
      * The files also define a ``CORRECT_CODING_FLAGS`` variable whose function may be unclear,
        but the ``CMakeLists.txt``-file for ``KITE-tools`` shows that it is meant to add additional
        warning flags. However, it is used inconsistently in both files and it should really be
        defined when calling ``cmake`` so that it can work with all compilers.
      * When OpenMP is not detected, some of the ``CMAKE_CXX_FLAGS*``-variables get overwritten
        rather than added to. This is again a bad idea.
      * At several places, directories are added to the include path that are only relevant to
        the system of the developer. On other systems this may even lead to problems should
        that directory exist but, e.g., contain a wrong version of the include files.
      * If essential software (such as the Eigen 3 include files) is missing, ``cmake`` should
        produce a clear error than just a status message.
      * I'm not sure that not giving the option to overwrite the information that should go
        in the ``compiletime_info.h``-file with something more meaningfull than what is
        auto-detected is a good idea.


## EasyBuild

There is no support for KITE in EasyBuild.

Given the number of packages that are called ``kite``, we decided to name the package
``Quantum-KITE`` after the URL of the web site.

### Commit 7e298ea - version 1.0 with Intel 2020a

  * Starting point: [commit 7e298ea](https://github.com/quantum-kite/kite/commit/7e298ea5d0c6f7761ce5cfdbaa6bcfb4af7421cb)
    of February 2.21 where the file ``version.md`` claims to be 1.0.
  * We studied 3 approaches to install KITE
      * Correcting the ``CMakeLists.txt`` files with the suggestions above did not work.
        There were still undefined symbols when linking ``KITE-tools``.
      * Adapting the ``compile_script.sh`` file (more a rewrite) was successful.
        See below for the script. It is not the most elegant procedure to integrate with
        EasyBuild though.
      * Construct Makefiles for the ``Src`` subdirectory (``KITEx``) and ``tools/src``
        subdirectory (``KITE-tools``). For the EasyBuild buld process, we decided to
        go for this approach and to inject them in the ``MakeCp`` EasyConfig file.
  * To avoid having two build process we also created a top-level Makefile that
    simply starts both build processes. Since there are more files that need
    copying we didn't implement a ``make install`` but simply use a ``MakeCp``
    EasyBlock.
  * Even though the executables ``KITEx`` and ``KITE-tools`` do not require Python
    at all, we decided to make ``kwant-bundle`` a dependency to ensure that it is
    used with a ``Python`` version with a compatible HDF5 library and since Pybinding
    is an official dependency in the documentation of KITE. Eigen is only a template
    library so is a build dependency.
  * Since some examples import kite.py, this has been put in a directory in the
    PYTHONPATH and precompiled via ``postinstallcmds``.


```bash
#!/bin/bash

ml calcua/2020a
ml intel/2020a
ml HDF5/1.10.6-intel-2020a-MPI
ml Eigen/3.3.7

CXX=icpc
CXXFLAGS="-O2 -ipo -march=core-avx2 -mtune=core-avx2 -std=c++17 -ftz -fp-speculation=safe -fp-model source -fPIC -qopenmp -Wall"
CXXDEF="-DVERBOSE=0 -DDEBUG=0"
CXXINCL="-I$EBROOTEIGEN/include -I$EBROOTHDF5/include"
LDFLAGS="-L$EBROOTHDF5/lib"
LDLIBS="-lhdf5_hl_cpp -lhdf5_cpp -lhdf5_hl -lhdf5 -lz -lm"

echo "Compiling KITEx and KITE-tools. To have the full functionality, you need to have at least version 8 of gcc."
echo "If you do not, you will not be able to run guassian_wavepacket. To enable compiling with this feature, please edit this file and set WAVEPACKET=1"
WAVEPACKET=1


# make the directory structure
rm -rf build tools/build
mkdir -p build
mkdir -p tools/build
mkdir -p bin

echo "Compiling KITEx"
cd build

for i in ../Src/*.cpp; do
  echo "Compiling $i"
  $CXX -c $i -DCOMPILE_WAVEPACKET=$WAVEPACKET  $CXXDEF $CXXFLAGS  -I../Src/ $CXXINCL
done

echo "Linking"
$CXX $CXXFLAGS *.o -o ../bin/KITEx $LDFLAGS $LDLIBS
echo "Done compiling KITEx."
cd ..


echo "Compiling KITE-tools"
cd tools/build

cat >compiletime_info.h <<EOF
#define MACHINE_NAME "${VSC_INSTITUTE_CLUSTER}"
#define SYSTEM_NAME "${VSC_ARCH_LOCAL}"
#define TODAY "$(date)"
EOF

for i in ../src/*.cpp; do
  echo "Compiling $i"
  $CXX -c $i $CXXDEF $CXXFLAGS -I. -I../Src/ -I../src/cond_2order $CXXINCL
done

for i in ../src/cond_2order/*.cpp; do
  echo "Compiling $i"
  $CXX -c $i $CXXDEF $CXXFLAGS -I. -I../Src/ -I../src/cond_2order $CXXINCL
done

for i in ../src/cond_dc/*.cpp; do
  echo "Compiling $i"
  $CXX -c $i $CXXDEF $CXXFLAGS -I. -I../Src/ -I../src/cond_2order $CXXINCL
done

echo "Linking"
$CXX $CXXFLAGS *.o -o ../../bin/KITE-tools $LDFLAGS $LDLIBS
echo "Done compiling KITE-tools."

cd ../..

echo "Add the directory $(pwd)/bin to the PATH and make sure HDF5/1.10.6-intel-2020a-MPI or kwant-bundle/1.4.2-intel-2020a-Python-3.8.3 is loaded when running KITE."
```
