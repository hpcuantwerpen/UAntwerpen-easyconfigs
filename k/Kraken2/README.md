# Kraken2 instructions

* [Kraken2 web site](http://www.ccb.jhu.edu/software/kraken2/)
* [Kraken2 on GitHub](https://github.com/DerrickWood/kraken2)
    * [Releases via GitHub](https://github.com/DerrickWood/kraken2/releases)

## General information

None.

## EasyBuild

Developement of this documentation started for the 2020a toolchains. Kraken2
was in beta at that time and at version 2.0.9.

There is [EasyBuild support for Kraken2](https://github.com/easybuilders/easybuild-easyconfigs/tree/develop/easybuild/easyconfigs/k/Kraken2).

### 2.0.9-beta

* EasyConfig development started from the EasyBuilders file for version 2.008-beta
* Switched to the Intel toolchain (from gompi)
* Needed to edit the sed-command as the Makefile moved to a different directory.
