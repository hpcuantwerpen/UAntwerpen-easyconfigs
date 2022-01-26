# Python @ UAntwerp documentation

This documentation was started with the 2020a toolchain.

* [Python web site](https://www.python.org/)
    * [Overview of releases](https://www.python.org/downloads/)



## General information

### Core Python dependencies

* A look at the configure of 3.8.2:
   * Core Python depends on Tcl/Tk as the tkinter package is nowadays part of the Python
     Standard Library
   * Core Python can use libffi for the _ctypes module
   * Core Python can use [libmpdec](https://www.bytereef.org/mpdecimal/) for the _decimal
     module.
   * Core Python can use expat for the pyexpat module.
   * Core Python also needs the OpenSSL libraries.
* Dependency check via ldd on all files in `lib/pythonx.y/lib-dynlib', for Core Python 3.8:

<table>
<tr><th> Module   </th><th> Package    </th><th> Library              </th><th> Python package </th></tr>
<tr><td> baselibs </td><td> zlib       </td><td> libz                 </td><td> zlib, tkinter, binascii  </td></tr>
<tr><td> baselibs </td><td> bzip2      </td><td> libbz2               </td><td> bz2 </td></tr>
<tr><td> baselibs </td><td> XZ         </td><td> liblzma              </td><td> lzma </td></tr>
<tr><td> baselibs </td><td> libffi     </td><td> libffi               </td><td> ctypes </td></tr>
<tr><td> baselibs </td><td> readline   </td><td> libreadline          </td><td> readline </td></tr>
<tr><td> baselibs </td><td> ncurses    </td><td> libncurses, libpanel </td><td> readline, curses, curses.panel </td></tr>
<tr><td> baselibs </td><td> mpdecimal  </td><td> libmpdec             </td><td> decimal </td></tr>
<tr><td> baselibs </td><td> expat      </td><td> libexpat             </td><td> pyexpat, xml.parsers.expat </td></tr>
<tr><td> baselibs </td><td> PCRE       </td><td> libpcre              </td><td> ssl, hashlib </td></tr>
<tr><td> baselibs </td><td> util-linux </td><td> libuuid              </td><td> uuid    </td></tr>
<tr><td> baselibs </td><td> libpng     </td><td> libpng16             </td><td> tkinter </td></tr>
<tr><td> baselibs </td><td> fontconfig </td><td> libfontconfig        </td><td> tkinter </td></tr>
<tr><td> baselibs </td><td> freetype   </td><td> libfreetype          </td><td> tkinter </td></tr>
<tr><td> SQLite   </td><td> SQLite     </td><td> libsqlite3           </td><td> sqlite3 </td></tr>
<tr><td> Tcl      </td><td> Tcl        </td><td> libtcl8.6            </td><td> tkinter </td></tr>
<tr><td> Tk       </td><td> Tk         </td><td> libtk8.6             </td><td> tkinter </td></tr>
<tr><td> X11      </td><td> X11        </td><td> libX11               </td><td> tkinter </td></tr>
<tr><td> X11      </td><td> Xau        </td><td> libXau               </td><td> tkinter </td></tr>
<tr><td> X11      </td><td> xcb        </td><td> libxcb               </td><td> tkinter </td></tr>
<tr><td> X11      </td><td> Xdmcp      </td><td> libXdmcp             </td><td> tkinter </td></tr>
<tr><td> X11      </td><td> Xext       </td><td> libXext              </td><td> tkinter </td></tr>
<tr><td> X11      </td><td> Xft        </td><td> libXft               </td><td> tkinter </td></tr>
<tr><td> X11      </td><td> Xrender    </td><td> libXrender           </td><td> tkinter </td></tr>
<tr><td> X11      </td><td> Xss        </td><td> libXss               </td><td> tkinter </td></tr>
</table>

* The ssl Python package uses libssl and related libraries, but we prefer to use the
  OS versions since they get patched from time to time.
* The configure help also talks about dbm backends. TODO: Check what we need to do
  there.
* Core Python does include SQLite support, which can link to an external libsqlite3
  (see table above).
* There is a gettext package but it seems to rely on the os package and not use
  the gettext from baselibs for the gettext functionality. There is likely similar
  functionality included in libc or so which is used instead.

### Packages included in Python

* Core Python does come with included ``pip``, ``easy_install``, ``distutils`` packages.

### Non-standard library packages that interface to external libaries

* NumPy: Link to MKL and can use SuiteSparse
* mkl_random: Link to certain MKL random number generators
* mkl_fft: Interface to the MKL FFT routines
* SciPy: Interfaces to various MKL components
* mpi4py: Interface to the MPI libraries
* h5py: Interface to the HDF5 libraries
* lz4: Interfaces to the lz4-library in baselibs
* PyYAML: Interfaces to libyaml in baselibs
* cffi: Interfaces to libffi in baselibs
* pysam: Provides a low-level interface to htslib (part of SAMtools)
* psutil: Interfaces to the system libraries for process management
* pycrypto: Interfaces to the system libraries for security features
* ecdsa: Interfaces to the system libraries for security features
* bcrypt: Interfaces to the system libraries for security/cryptography features
* PyNaCl: Interfaces to libsodium, a libary for enctyption, decryption, etc.
  (we use the included one)
* netifaces: Interfaces to system libraries
* pyzmq: Interfaces to libzmq, but seems to contain it.
* pysqlite3: Alternative interface to libsqlite3, needed by the USPEX code.

* cryptography: Interfaces to several OS security libraries, including libssl and
  libcrypto5
* PyTables (PyPi: tables): Interface to the HDF5 libraries and to bzip2, LZO and Blosc
  in baselibs.
    * Dependencies of PyTables: Cython, NumPy, Numexpr, HDF5 library, LZO/LZO2 libary,
      BZIP2 library. Blosc is an optional dependency; it also includes the code.
    * Compile problems with 3.6.1 on 3.8.2, see the Python 3.8.2-section for the solution.
* matplotlib: Uses libbz2, libpng16, libz and libfreetype from baselibs but no direct
  dependencies on X11.
* lxml: Interfaces to libxml2/libxslt (baselibs)
* scikit-learn
* gmpy2: Interfaces to GMP, MPC and MPFR (baselibs)

* tinyarray: Offers a data type, uses standard system libraries
* greenlet: Lightweight concurrent programming, uses standard system libraries
* ujson: JSON encoder/decoder, uses only standard system libraries
* scandir: directory iteration function, uses only standard system libraries
* blist: Drop-in for Python lists, uses only standard system libraries
* memory_profiler: Uses only standard system libraries
* spglib: Depends on NumPy and standard system libraries
* pycosat: Interface to the picosat solver, included in the distribution, and uses
  standard system libraries.
* ruamel.yaml.clib: C based reader/scanner and emitter for ruamel.yaml, uses standard
  system libraries.
* sip: SIP is a collection of tools that makes it very easy to create Python bindings
  for C and C++ libraries, used by, e.g., PyQt. Uses standard system libraries but
  has a lot of other dependencies and is therefore further down in the build tree.

### Notes on some other packages

#### pandas

* Package that generates a lot of shared libraries. However, they only interface to
  standard libraries
* Requires pytz, python-dateutil
* Installs without PyTables, but can use it. PyTables is on PyPi as ``tables`` and
  provides an interface to HDF5.

#### sklearn

* Package that generates a lot of shared libraries. However, they only interface to
  standard libraries


## EasyBuild generics

### Python EasyBlock

Python is build through an EasyBlock that does add some stuff to the installation
for all the EasyBuild trickery.

Python config options defined by the EasyBlock:
* optimized: Build with expensive, stable optimizations (PGO, etc.,), supported from
  Python 3.5.4 on. The default is True.
* use_lto: Build with Link Time Optimization (Python 3.7.0 and later), but this is
  potentially unstable on some toolchains. The default value is "None" which does
  an auto-detect based on the toolchain compiler version.
* ebpythonprefixes: Create a special sitecustomize.py and allow the use of $EBPYTHONPREFIXES.
  The default is True.
* ulimit_unlimited: Ensure the stack size limit is set to unlimited during the build.
  The default is False.

### Python packages

* New versions of EasyBuild now use GCCcore to compile Python rather than the Intel
  compilers as it can then be used in multiple toolchains and as most of Python does
  not really benefit from the Intel compiler anyway.
    * **At UAntwerp we still try to get Python to compile with the Intel compiler.**
* EasyBuild does use the Intel compilers though for some performance critical packages.
    * SciPy-bundle is a bundle containing NumPy, SciPy, mpi4py, pandas and mpmath
      that should benefit from the Intel compiler. It is not clear what mpmath does
      in this bundle though as it has no dependencies besides the Python standard
      libary and is pure Python. It relies on the GMP library interface in the
      standard Python libary.

### NumPy

NumPy in EasyBuild is installed through an EasyBlock derived from FortranPythonPackage.

* Configure phase:
    * Builds a `site.cfg` file
    * Does the regular discovery for a Python package
    * Runs `python setup configure`
* Build phase: Runs `python setup build`, adding `buildopts` and appropriate
  `--compiler` and `--fcompiler` options. Note that this is done through the
  FortranPythonPackage generic EasyBlock.
* Test phase: The NumPy EasyBlock does perform a number of texts. Search in the log
  for `INFO Time for .* matrix dot product`.
* Install phase: Uses the regular install procedure for Python packages so will honour
  all regular Python package installation options (such as use_pip et.)

Notes:
* NumPy can use SuiteSparse which is recognized by the EasyBlock and the
  appropriate lines for AMD and UMFPACK are added to the site.cfg file.

### SciPy

SciPy in EasyBuild is installed through an EasyBlock derived from FortranPythonPackage.

* Configure phase: Just the regular discovery for a Python package. Note however that
  from version 0.13 onwards, `preinstallopts` is modified so be careful if you use
  that parameter.
* Build phase: The normal build phase for a Fortran Python package, i.e., running
  `python setup build`, adding `buildopts` and appropriate
  `--compiler` and `--fcompiler` options.
* Install phase: The regular install phase as for every Python package, but note
  that this will run with a modified `preinstallopts` from SciPy 0.13 onwards.


## EasyBuild packages in this directory

### Python 2.7.18 on 2020a

* Likely the last Python 2 module ever on our cluster. In fact, we plan to only install
  this module when a user has a really good case for it.
* Simple version update of all packages of the 2019b Python 2 module with some reordering
  to make sure dependencies are installed in the right order. This helps if part of
  the packages would be out-commented for a partial build.

### Python 3.7.7 on 2020a

* Provided as "spare" as we in fact also provide Intel Python to our users, which is
  the 3.7 branch in the 2020 compilers. This module will not be installed by default
  on our clusters.
* Added ``-fwrapv`` to the compiler flags, see remarks for 3.8 where it was essential.
* Packages are just a copy of the 3.8.2 ones.

### Python 3.8(.3) effort on 2020a.

* Builds with the Intel compiler need an additional option added to CFLAGS: ``-fwrapv``.
  This option doesn't seem to be documented in the Intel manuals. However, the GCC manual
  tells that this option instructs the compiler to assume that signed arithmetic overflow
  of addition, subtraction and multiplication wraps around using twos-complement representation.
  This flag enables some optimizations and disables others.
    * See [Python bug report 40223](https://bugs.python.org/issue40223)
    * See also remark of Stefan Krah in [this Intel forum](https://software.intel.com/en-us/forums/intel-c-compiler/topic/849064).
    * In fact, the bug report and remarks of Stafan Krah suggest that this option is useful in
      Python 3.7 also and should also be used when using GCC.
* After a raw Python install (without any additional packages beyond the standard library)
    * distutils is available, version 3.8.2
    * pip is available through the ``pip3`` command. The version is 19.2.3, which was not
      the latest one but a fairly recent one. Pip 19.3 launched on the same day as Python 3.8.2,
      and there have been more new version, so supposedly maintenance releases stich with the
      versions of packages available during testing of the .0-version.
    * setuptools is also included, but again a slightly older version (41.2.0)
    * All this suggest to include newer pip and setuptools in even the most basic Python module.
* The baselibs module was further extended to make sure that all standard library packages
  use our own installed versions of software rather than the system versions, with
  the exception of security-related libraries. Those are taken from the OS image to
  be sure that they get updated whenever security patches become available.
* We've tried to move a number of packages that require heavy compiler work as high
  up the chain as possible so that errors show as quickly as possible.
    * NumPy, SciPy and pandas are three packages that take quite some time to compile.
    * mpi4py interfaces to the MPI libraries
    * h5py and tables (also known as PyTables) interface to the HDF5 libraries.
    * In fact, we first install packages that use various libraries installed in the
      toolchain (and the dependencies that are absolutely needed for this), then most
      packages that need compilation but use only system libraries and compiler runtimes
      and after that all packages that only contain Python code.
* It turned out that NumPy needs a sufficiently recent version of Cython to compile
  even though it did not complain that Cython was not yet present; the build simply crashed.
* PyTables (PyPi: tables) needs some trickery
    * Compilation of PyTables fails due to wrong linker options: It uses -l-liomp5
      -l-lpthread. This may come from prepending -l to the contents of
      python3.8/_sysconfigdata__linux_x86_64-linux-gnu.py. The solution is to define
      LIBS="iomp5 pthread", overwriting the _sysconfigdata_.
    * PyTables had trouble finding bzip2, LZO and Blosc, so we also defined the
      environment variables BZIP2_DIR, LZO_DIR and BLOSC_DIR, all with the value
      $EBROOTBASELIBS (which is the module that contains those libraries).
    * Note that we also set CC and CXX to mpiicc and mpiicpc respectively as we link with
      the HDF5-library with MPI support.
* In January 2022 the EasyConfig file was adapted to work with EasyBuild 4.5.0 as it
  failed to install `pip` and `setuptools`.


### TODO

* Move pysam to bioinformatics module and use
export HTSLIB_LIBRARY_DIR=/usr/local/lib
export HTSLIB_INCLUDE_DIR=/usr/local/include
pip install pysam
