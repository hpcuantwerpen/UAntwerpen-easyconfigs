# Flye installation instructions

* [Flye on GitHub](https://github.com/fenderglass/Flye/)
* [Flye in Bioconda](https://bioconda.github.io/recipes/flye/README.html)

## General remarks

* Flye uses several other packages, including minimap2 and SAMtools. However,
  rather than using existing libraries on the system, it includes all code
  and there seems to be no option to build using already existing libraries.
  The downside is that there is no guarantee that these libraries will always
  be properly optimized.

## EasyConfigs

Flye has support in EasyBuild so we simply adapt the default EasyBuild recipes for 
Flye.

### Version 2.7

* As 2.7 was not yet supported in EasyBuild, we made trivial changes to a default 
  2.6 recipe.
* The build/install phase does produce an error message about a wheel not being generated
  yet the result appears to be OK. It certainly passes the ``import flye`` test.

### Version 2.7.1 - 2020a toolchains

* Moved to the BioTools-Python bundle
* The test file here uses some very special tricks to prepare to move to the BioTools-Python 
  bundle.
    * We want to install Flye as an extension in that Bundle. The problem is that
      Flye is downloaded from GitHub and does have a meaningless filename (essentially
      the version with an extension) so that file name conflicts could occur in the sources
      repository should one have another such package with the same version number.
    * The solution is to not use PythonBundle, but Bundle as the main EasyBlock, and then
        * Use a component that does nothing to download the sources and use a meaningful name
          for the file. For this, we use Tarball components and skip the install step.
        * Set the class for extensions to "PythonPackage"
        * Install Flye again in the extensions just as we would for any Python package
        * But now we also need to manually adjust PYTHONPATH in the recipe.

