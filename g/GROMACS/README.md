# GROMACS installation instructions

## General information

GROMACS uses CMake for configuration. A number of important variables are:

<table>
<tr><th>Variable</th><th>Default</th><th> What?</th></tr>
<tr><td>GMX_DOUBLE</td><td>OFF</dt><td>Use double precision</td></tr>
<tr><td>GMX_OPENMP</td><td>ON</dt><td>Use OpenMP</td></tr>
<tr><td>GMX_MPI</td><td>OFF</dt><td>Use MPI</td></tr>
<tr><td>GMX_THREAD_MPI</td><td>ON</dt><td>Build a thread-MPI-based multithreaded version of GROMACS (not compatible with MPI)</td></tr>
<tr><td>GMX_SIMD</td><td>AUTO</dt><td>AUTO seems to do the job of selecting the right SIMD code well enough</td></tr>
<tr><td>GMX_GPU</td><td>OFF</dt><td></td></tr>
<tr><td>GMX_USE_OPENCL</td><td>OFF</dt><td>Enable OpenCL acceleration</td></tr>
<tr><td>GMX_X11</td><td>OFF</dt><td></td></tr>
<tr><td>GMX_FFT_LIBRARY</td><td>fftw3</dt><td>Indicate which FFT library should be used (e.g., mkl)</td></tr>
<tr><td>GMX_EXTERNAL_BLAS</td><td>O</dt><td></td></tr>
<tr><td>GMX_EXTERNAL_LAPACK</td><td>O</dt><td></td></tr>
<tr><td>GMX_USE_TNG</td><td>ON</dt><td>Use the TNG library for trajectory I/O</td></tr>
<tr><td>GMX_EXTERNAL_TNG</td><td>OFF</dt><td></td></tr>
<tr><td>GMX_EXTERNAL_ZLIB</td><td>OFF</dt><td></td></tr>
<tr><td>GMX_PREFER_STATIC_LIBS</td><td>O</dt><td></td></tr>
<tr><td>BUILD_SHARED_LIBS</td><td>ON</dt><td>Try OFF in case of segmentation violations.</td></tr>
</table>


## EasyConfigs

We switched from using the EasyBuilders recipes that are based on a custom EasyBlock 
for GROMACS to our in-house-developed recipes that use the CMakeMake EasyBlock. The 
reason is that we wanted to make clearer which CMake options were used to be able to 
better play with those options and work around problems.

We use a Bundle setup to generate multiple executables with and without MPI and in 
single or double precision.

### Installation hints

* Search for "Test project" to locate the tests in the EasyBuild log file.

### GROMACS 2018.2, Intel 2018b toolchain

* GROMACS recognizes the Intel compilers and choses options that it deems appropriate. 
  They are added to the default options that EasyBuild tries to impose. Since we assume 
  that the options were in fact carefully chosen (as they are nontrivial) we prevent
  EasyBuild from overwriting these. Benchmarking of GROMACS 2018.2 on our systems for
  a problem from one of our users also showed better performance if we did not try 
  to impose the EasyBuild compiler options which was an additional motivation for us
  to leave behind the GROMACS EasyBlock.
* Yet on machines with AVX and no AVX2 it turns out that some floating point tests 
  fail in the underflow range. Adding the floating point option ``-no-ftz`` cures this
  problem. Since this may have a negative influence on performance we only use this
  option on our Ivy Bridge cluster.

### GROMACS 2019.4, Intel toolchain

* The problem with test failing on Ivy Bridge still occurs with GROMACS 2019.4
  and the Intel 2019 compilers.
* Due to the immaturity of the Intel 2019 MPI implementation, we also generated 
  executables with the Intel 2018 compilers ()2018b toolchain).
* The Intel 2019 update 5 compilers crash when compiling GROMACS 2019.4. Update 4
  works.

#### PLUMED 2.6.0 integration

* PLUMED 2.6.0 contains a patch to integrate with GROMACS 2019.4. This can be installed
  through the ``plumed patch -p -e gromacs-2019.4`` command, before configuration with 
  CMake according to the GROMACS and PLUMED manuals.
* Single precision executables fail with segmentation violations during a number of 
  tests when using the Intel 2019 update 4 compilers for PLUMED and GROMACS.

### GROMACS 2020.2, Intel toolchain

* Did a straightforwared port from the 2019.4 EasyConfig.

### GROMACS 2021.1, Intel toolchain

* Replaced -DGMX_SIMD=AUTO by -DGMX_SIMD=AVX2_128 for Rome/Zen2 only, following
  https://manual.gromacs.org/documentation/2021/install-guide/index.html#simd-support
* Needs 2020.4 compilers (problems with 2020.0), so slight workaround for toolchain 
  on Rome/Zen2 
* Added -DGMXAPI=OFF
* Removed "check" from make in CUDA version

