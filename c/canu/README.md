# Canu installation instructions

* [Canu homepage on readthedocs](https://canu.readthedocs.io/en/latest/)
* [Canu Git/hub](https://github.com/marbl/canu)
* [Canu in Bioconda](https://bioconda.github.io/recipes/canu/README.html)

## Instructions

The instructions are extremely unclear when it comes to the dependencies.
According to the Bioconda recipe, one needs
* Perl with the Filesys-Df package
* GNUplot
* OpenJDK (or another Java JDK)
* Boost also appears to be necessary.

## EasyConfigs

Canu has support in EasyBuild (package canu). Our EasyConfigs were derived from the 
standard ones.

### Canu 1.9 in Intel/2019b

* Started from EasyConfigs for version 1.8 with Intel 2017b and 1.9 with GCCcore.

### Canu 2.0 in Intel/2020a

* Trivial adaptations of the 1.9 EasyConfig
