# phonpy instructions

 * [phonopy home page with documentation](http://phonopy.github.io/phonopy/)
 * [phonopy on PyPi](https://pypi.org/project/phonopy/)
 * [phonopy development on GitHub](https://github.com/phonopy/phonopy)

## General information

 * phonopy is a Python package. It does contain C code also though.
 * Dependencies include matplotlib. lxml, PyYAML and h5py which are in the 
   base Python modules at UAntwerpen.
 * We should consider bundling with, among others, phono3py.

## EasyBuild

There is [support for phonopy in the EasyBuilders 
repository](https://github.com/easybuilders/easybuild-easyconfigs/tree/master/easybuild/easyconfigs/p/phonopy).

Our EasyBuild recipes need to be adapted since we include a lot more packages in 
the base Python modules.

### 2.6.0 for 2020a toolchains

 * We had to stuck to 2.6.0 instead of 2.6.1 since the latter was not available in 
   a suitable source form.
 * Build for Python 3.8 and the Intel Python 3 distribution.
 * Verified with the state of the EasyBuilders modules.
 * Updated the documentation section in the module file.
