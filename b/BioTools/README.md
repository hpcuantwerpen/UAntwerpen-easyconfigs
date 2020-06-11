# BioTools instructions

BioTools is a bundle of tools popular in the bioinformatics groups at UAntwerpen.
It was developed to reduce module clutter on our systems.

## Packages

* [HTSlib](http://www.htslib.org/)
    * [Development on GitHub](https://github.com/samtools/htslib)
* [bedtools 2](https://bedtools.readthedocs.io/en/latest/)
    * [Development on GitHub](https://github.com/arq5x/bedtools2)
    * Claims to use HTSlib since version 2.28, but it actually includes the necessary
      code and doesn't seem to have an option yet to include an existing HTSlib library.
      In fact, the version it includes is rather old and the code relies on features 
      of that old version that are not present in current versions anymore.
    * No configure or CMake, only a Makefile... It does have a ``make install prefix=...`
      though.
* [CD-HIT](http://weizhongli-lab.org/cd-hit/)
    * [Develpment on GitHub](https://github.com/weizhongli/cdhit)
    * MakeCp build process to ensure that we also install some files that are not
      done by `make install`.
* [ClonalFrameML](https://github.com/xavierdidelot/ClonalFrameML)
    * MakeCp build process
* [fastp](https://github.com/OpenGene/fastp)
    * Just a make/make install build process, and several variables needed to get the
      compiler and optimizations right.
* [MCL](http://micans.org/mcl/)
    * ConfigureMake, but there are two files that are not copied by the make install.
* [Minimap2](https://github.com/lh3/minimap2)
    * MakeCp, and needs some tricks
    * Ancient: no multicore parallelism, SIMD support only up to SSE 4.1.
* [MUSCLE](http://drive5.com/muscle/)
    * MakeCp, but does need a patch as the compiler name is hard-coded in the Makefile
      and not even in a variable that we can overwrite
* [VSEARCH](https://github.com/torognes/vsearch)
    * Autotools-based, but needs some preprocessing and configopts.


## EasyConfigs

### 2020a bundles

* HTSlib 1.10.2
* BCFtools 1.10.2
* CD-HIT 4.8.1
* ClonalFrameML 1.12
* SAMtools 1.10
* bedtools 2.29.2
* fastp 0.20.1
* MCL 14.137
* minimap 2.17
* MUSCLE 3.8.31
* VSEARCH 2.14.2




