# Unicycler instructions

  * [Unicycler on GitHub](https://github.com/rrwick/Unicycler)
      * [REleases](https://github.com/rrwick/Unicycler/releases)
  * Unicycler is no longer on PyPi.


## General information

  * Unicycler is a Python package interfacing to a lot of other tools.


### Dependencies

There is no clear list of dependencies in the documentation. This list is assembled
from whatever is in the README.md file and from the EasyBuilders recipes.

  * Python
  * [Pilon](https://github.com/broadinstitute/pilon): Java package, and very slow in 
    development (1.23 release in November 2018) - So Java also enters as a dependency
  * [BLAST+](https://blast.ncbi.nlm.nih.gov/)
  * [Bowtie2](https://github.com/BenLangmead/bowtie2)
  * [miniasm](https://github.com/lh3/miniasm) - part of our BioTools package since 
    2020a
  * [Racon](https://github.com/lbcb-sci/racon) - part of our BioTools package since 2020a
  * [SAMtools](http://www.htslib.org/) - part of our BioTools package since 2020a
  * [SPAdes](http://cab.spbu.ru/software/spades/) - separate since it poses compile challenges


## EasyBuild

This documentation was first written when installing version 0.4.8 in the 2020a toolchains.

There is [support for UniCycler in the EasyBuilders 
repository](https://github.com/easybuilders/easybuild-easyconfigs/tree/master/easybuild/easyconfigs/u/Unicycler).


### Version 0.4.8, 2020 toolchains

  * Developed from the 0.4.7 one, but updated to use BioTools were possible.
  * Added miniasm as a dependency, which was missing in the EasyBuilders EasyConfig. 
