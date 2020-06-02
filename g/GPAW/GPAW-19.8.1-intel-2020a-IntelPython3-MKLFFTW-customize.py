"""User provided customizations.

Here one changes the default arguments for compiling _gpaw.so (serial)
and gpaw-python (parallel).

Here are all the lists that can be modified:

* libraries
* library_dirs
* include_dirs
* extra_link_args
* extra_compile_args
* runtime_library_dirs
* extra_objects
* define_macros
* mpi_libraries
* mpi_library_dirs
* mpi_include_dirs
* mpi_runtime_library_dirs
* mpi_define_macros

To override use the form:

    libraries = ['somelib', 'otherlib']

To append use the form

    libraries += ['somelib', 'otherlib']
"""

#
# NOTES:
# - This script is based on the example customize.py
# - Also have a look at config.py as this sets the default parameters.
#

# Convert static library specs from EasyBuild to GPAW
def static_eblibs_to_gpawlibs(lib_specs):
    return [libfile[3:-2] for libfile in os.getenv(lib_specs).split(',')]

# Clean out any autodetected things, we only want the EasyBuild
# definitions to be used.
libraries = []
mpi_libraries = []
# Don't create an empty include_dirs as otherwise the NumPy include files are not found.
#include_dirs = []

# FFTW should be configured from environment variables, but they do
# not report the correct names for a dynamically loaded library.
fftw = True
# Use Intel MKL
#libraries += ['mkl_sequential','mkl_core', 'fftw3xc_intel_pic', 'mkl_rt', ] # The list in config.py also contains mkl_intel_lp64
libraries += ['fftw3xc_intel_pic'] # MKL BLAS libs are added further down and these contain the other MKL libraries also needed for the FFT.


# # Use EasyBuild fftw from the active toolchain
# fftw = os.getenv('FFT_STATIC_LIBS')
# if fftw:
#     # Ugly hack: EasyBuild only knows of the versions of the FFTW libs built without -fPIC
#     for thislib in static_eblibs_to_gpawlibs('FFT_STATIC_LIBS'):
#         if thislib.startswith('fftw') and thislib.endswith('_intel'):
#             thislib = thislib + '_pic'
#         libraries.append(thislib)

# Use ScaLAPACK:
# Warning! At least scalapack 2.0.1 is required!
# See https://trac.fysik.dtu.dk/projects/gpaw/ticket/230
# Use EasyBuild scalapack from the active toolchain
scalapack = os.getenv('SCALAPACK_STATIC_LIBS')
if scalapack:
    mpi_libraries += static_eblibs_to_gpawlibs('SCALAPACK_STATIC_LIBS')
    mpi_define_macros += [('GPAW_NO_UNDERSCORE_CBLACS', '1')]
    mpi_define_macros += [('GPAW_NO_UNDERSCORE_CSCALAPACK', '1')]

# Add EasyBuild LAPACK/BLAS libs
libraries += static_eblibs_to_gpawlibs('BLAS_LAPACK_STATIC_LIBS')

# LibXC:
# Use EasyBuild libxc
libxc = os.getenv('EBROOTLIBXC')
if libxc:
    include_dirs.append(os.path.join(libxc, 'include'))
    if 'xc' not in libraries:
        libraries.append('xc')

# libvdwxc:
# Use EasyBuild libvdwxc
libvdwxc = os.getenv('EBROOTLIBVDWXC')
if libvdwxc:
    include_dirs.append(os.path.join(libvdwxc, 'include'))
    libraries.append('vdwxc')

# ELPA
# Use EasyBuild ELPA
elpa = os.getenv('EBROOTELPA')
if elpa:
    include_dirs.append(os.path.join(elpa, 'include/elpa'))
    libraries.append('elpa')

# Now add a EasyBuild "cover-all-bases" library_dirs
#library_dirs = os.getenv('LD_LIBRARY_PATH').split(':')
library_dirs = os.getenv('LIBRARY_PATH').split(':')

# We need to set the compiler variable to make sure that the GNU compiler
# options are correctly removed (which also requires the option 
# --remove-default-flags to setup.py)
if 'CC' in os.environ:
    compiler = os.getenv('CC')
    linker = compiler

# Build separate gpaw-python
if 'MPICC' in os.environ:
    mpicompiler = os.getenv('MPICC')
    mpilinker = mpicompiler

# We had trouble at some point when the arguments where not correctly
# split. The compiler saw the whole string as a single argument, probably
# because of the way distutils calls external commands. Hence the split.
extra_compile_args = os.getenv('CFLAGS').split(' ')