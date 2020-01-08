# Installing protobuf with EasyBuild

Protobuf supports two build procedures:
* autotools-based: I read somewhere on a forum that this is deprecated and will
  be removed in a future version (read this while trying to build protobuf for
  the 2019b toolchains). We did run into problems trying to compile protobuf
  3.10 and 3.11 with GCCcore 8.3.0.
* cmake: In late 2019 still marked as "experimental" and in the corresponding
  documentation as meant for Windows. This is demonstrated by python/setup.py
  which looks in the directories that would have been created with an
  autotools-based build.

Protobuf contains several components
* The src directory contains the actual sources for the protoc command and the
  protobuf libraries.
* Then there are various interfaces to other languages
   * python contains the Python interface.

## Problems installing protobuf

Protobuf has been generating warnings for a long time when compiled with the
Intel compilers. This can be circumvented by adding a suitable `-wd`-option
to `CXXFLAGS`, e.g., `-wd2196,858,177`.

However, even with these options, protobuf cannot be compiled with the Intel 2019
compilers. It fails with a "static assertion failed" error on line 341 of 
`src/google/protobuf/arena.h` triggered by a template instantiation on line
193 of `src/google/protobuf/extension_set.cc` (line numbers for protobuf 3.11.2).
It does compile however with the GNU compilers which encourages to move protobuf 
from the Intel toolchain to the matching GCCcore toolchain.

However, this then gives problems to generate the Python-interfaces when Python is 
compiled with the Intel compilers. The setup.py script uses distutils (and some 
elements from setuptools) and that is very rigid when configuring the compiler.
It gets the compiler and flags from the file `_sysconfigdata_m_linux_x86_64-linux-gnu.py`
in `lib`python*` from the Python module. However, it does allow to replace or
augment certain options. The way in which it does this however is broken.
* The C and C++ compiler can be overwritten by setting the environment variables
  `CC` or `CXX` respectively to the desired compiler.
* However, there is no way to overwrite the recorded compiler flags. One can define
  `CFLAGS` in the environment and these flags will be added to the once recorded.
  If the compiler gives precedence to a flag further on the command line, this may 
  still have the desired effect. However, it does not work if the new C or C++ 
  compiler does not accept all the options that were used when building Python.
  This is definitel the case for a Python build with EasyBuild using the Intel
  toolchain.

The workaround consists of:
* Copy the file `_sysconfigdata_m_linux_x86_64-linux-gnu.py` from the Python module
  directories to the directory with `setup.py` of protobuf.
* Edit that file with `sed`: We rename the `CFLAGS` directory entry to `CFLAGS1` 
  (because renaming is easier than to delete this often multiline entry) and re-add
  the entry `CFLAGS` with an empty string as a value.
* And we make sure that the file is in front of the system one in the PYTHONPATH by
  putting the current directory in front.

## Our EasyConfig files

### Protobuf 3.11.2 for the 2019b toolchains (intel/2019b with GCCcore/8.3.0)

* We made a switch to CMake. A consequence of this is that only a shared library
  could be generated. We did try autoconf also, but the compilation failed with
  errors about undefined symbols (and it was googling for those error messages 
  that we found the suggestion to try CMake instead).
* Even though we still emply the Intel compiler for some Python modules, due to the
  difficulties to compile with the Intel 2019 compilers we switched to the GCCcore
  subtoolchain. This implies that we faced difficulties to generate the Python 
  interface as explained above. We implemented the solution as explained above.
* Preparing the Python module is done during the build step, after building the
  libraries but before these are moved to their final location. The installation of
  the Python interface is then done at the end of the install step.
* As the EasyConfig is just a CMakeMake file, it does not know about Python. 
  Hence there is no automatic check of the Python module nor is the PYTHONPATH
  adjusted automatically in the module. We added the necessary line for the latter
  one but do not yet implement a test for the Python module.
* Note that we've tried to implement a test using 
  `tests = ["PYTHONPATH=%(installdir)s/lib/python%(pyshortver)s/site-packages:$PYTHONPATH python -c 'import google.protobuf'"]`
  but that doesn't work due to strange restrictions in EasyBuild. The test should start 
  with a very specific absolute path or the test script should be found in one of
  the source directories.
