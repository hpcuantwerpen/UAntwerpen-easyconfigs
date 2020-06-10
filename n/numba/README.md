# numba instructions

  * [numba home page](http://numba.pydata.org/)
  * [numba on PyPi](https://pypi.org/project/numba/)
  * [numba on GitHub](https://github.com/numba/numba)
      * Note that there are other interesting repositories with
        examples, documentation, benchmarking code, ...
        in the [numba GitHub account](https://github.com/numba).

## numba dependencies

  * Numba relies on the LLVM backend. It accesses that backend through the
    [llvmlite package](https://pypi.org/project/llvmlite/) 
    ([code on GitHub](https://github.com/numba/llvmlite/tree/master/conda-recipes)).
    Each version of llvmlite supports only specific versions of LLVM, so match
    them based on the information in the [LLVM README on
    GitUb](https://github.com/numba/llvmlite/blob/master/README.rst).

## EasyConfig

We developed our own EasyConfig, partially starting from the one for LLVM. Our recipe
contains 3 packages:
  * First a suitable version of LLVM is installed. Supported versions depend on what 
    llvmlite supports at that moment, and those versions are often considerably older 
    than the version that we would want for a Clang/Flang compiler toolchain.
  * Next the Python llvmlite package is installed.
  * Finally the Python numba package itself is installed.

The options that we use for compiling LLVM are very different from those used in the 
EasyBuilders recipe for LLVM. They were taken from [the scripts of `llvmlite` to install
in a Conda environment](https://github.com/numba/llvmlite/blob/master/conda-recipes/llvmdev_manylinux1/build.sh). 

Note that some of the Conda recipes do advise to use certain patches.
The patches can be found in the [conda-recipes subdirectory of the 
llvmlite GitHub](https://github.com/numba/llvmlite/tree/master/conda-recipes).

Compiling LLVM with those options failed if `'pic'` was not set to `True` (since we 
didn't have the shared library function turned on, this option was not set automatically).

### 2020a to0lchains: Numba 0.49.1, llvmlite 0.32.1 and LLVM 8.0.1 (and 2019b backport)

  * It is still impossible to compile LLVM with the Intel compilers so we stuck to GCCcore.
    However, we've played it dirty and claim that the module belongs in the Intel toolchain
    to not confuse our users who have to load a combination of GCCcore and Intel modules.
  * Backport to 2019 based on numba 0.48.0 since a program using it turned out to be
    incompatible with Numba 0.49.1
  * We did not apply any of the LLVM patches in the [conda-recipes subdirectory of the 
    llvmlite GitHub](https://github.com/numba/llvmlite/tree/master/conda-recipes) as 
    so far we did not run into compile or link problems or observe problems when using
    numba. They may be needed though in rare or in future cases.
  
