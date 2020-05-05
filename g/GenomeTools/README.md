# GenomeTools installation instructions

## General information

* GenomeTools wasn't updated much between 2017 and early 2020. Problems started to 
  arrise with new versions of Pango and cairo.
* GenomeTools includes most other dependencies. See 
  [the direcotry src/external](https://github.com/genometools/genometools/tree/master/src/external)
  Some of those libraries are really ancient and one can hence expect that newer versions
  may not work. Though it is possible to use already installed versions instead of 
  the included onces by specifying useshared=yes on the make command line, it is not 
  advised since some of the versions are so old we might expect new versions may not 
  be compatible with the code. This is particulary the case for the included samtools.

## EasyConfigs

Our own EasyConfig is derived from the EasyBuilders EasyConfigs for GenomeTools.
