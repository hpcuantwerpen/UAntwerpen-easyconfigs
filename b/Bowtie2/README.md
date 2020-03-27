# Bowtie installation instructions

* [Bowtie GitHub](https://github.com/BenLangmead/bowtie2)
* [Bowtie on SourceForge](http://bowtie-bio.sourceforge.net/bowtie2/index.shtml)

## EasyConfigs

We developed our own Bowtie2 EasyBuild recipes, first based on the MakeCp easyblock, 
but moving to CMakeMake cince version 2.3.5.1. This is to have more control over the
options than when using the Bowtie2 EasyBlock that is used in the EasyBuilders recipes.


### 2.3.5.1, 2018b and 2019b toolchains

CMake for Bowtie2 sets a number of C compiler options in addition to the ones passed
to CMake. These are GNU-specific and should be removed as they do cause warnings.
Moreover, one of them, ''-msse2'', might even be counterproductive and force optimizing
for an older processor.

Hence the lines:
```
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -m64 -g3 -Wall -msse2")
set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -O0")
set(CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS_RELEASE} -O3 -funroll-loops")
```
should be replaced with
```
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS}")
set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG}")
set(CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS_RELEASE}")
```
(Changing the second line is not really needed)

### 2.4.1, 2020a toolchain

The patch for the compiler flags developed for version 2.3.5.1 is still needed in 2.4.1,
but the line numbers have changed so we needed to re-build the patch. Rather than 
using a patch though, we edit CMakeLists through sed in the preconfigopts.

Using
```
sed -e 's/ -m64 -g3 -Wall -msse2//' -e 's/ -O3 -funroll-loops//' -i CMakeLists.txt
```
we edit the lines 
```
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -m64 -g3 -Wall -msse2")
set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -O0")
set(CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS_RELEASE} -O3 -funroll-loops")
```
in `CMAkeLists.txt` to 
```
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS}")
set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -O0")
set(CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS_RELEASE}")
```
Note though that in later versions, a different edit might be needed!

Bowtie2 works with Intel TBB but it takes some care to get it to work that way.
* Not specifying any TBB options: The code includes its own TBB library (2019_U4) but
  that version does not compile with the Intel 2020 compilers. Note that this is 
  not specific to this version of Bowtie: Trying to recompile older versions 
  (that likely also use an older TBB version) also fails. It looks like the version 
  of TBB included in those codes is not compatible   with the Intel 19.1 compoilers 
  in the 2020a toolchain.
* Including TBB_LIB_PATH etc.: Though CMake is happy with it, the code fails to link. 
  It is not clear why it fails to find the appropriate libraries.
* The trick that does it is to add ``-tbb`` to the compiler flags combined with 
  the previous point (the TBB_LIB_PATH etc.) to make CMake happy.
* The alternative suggestion (not tried) would be to edit `CMakeLists.txt`` and
  the ``Makefile`` in the root source directory, search for ``2019_U4`` and replace
  with a newer version of TBB (``2020.1`` at the moment that the recipe was developed).
  Note that the URL to the GitHub repository of TBB is also outdated as the account\
  and project has changed name for oneAPI.
* The non-TBB build succeeds though (setting ``-DNO_TBB=1`).
  