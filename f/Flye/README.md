# Flye installation instructions

* [Flye on GitHub](https://github.com/fenderglass/Flye/)
* [Flye in Bioconda](https://bioconda.github.io/recipes/flye/README.html)

## EasyConfigs

Flye has support in EasyBuild so we simply adapt the default EasyBuild recipes for 
Flye.

### Version 2.7

* As 2.7 was not yet supported in EasyBuild, we made trivial changes to a default 
  2.6 recipe.
* The build/install phase does produce an error message about a wheel not being generated
  yet the result appears to be OK. It certainly passes the ``import flye`` test.
