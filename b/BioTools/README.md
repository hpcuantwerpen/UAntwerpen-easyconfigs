# BioTools instructions

BioTools is a bundle of tools popular in the bioinformatics groups at UAntwerpen.
It was developed to reduce module clutter on our systems.

## Packages

  * [BCFtools](https://www.htslib.org/)
      * ConfigureMake build process
      * Depends on HTSlib in this Bundle
      * BCFtools consists of a single binary, a number of Perl and Python scripts
        and a large number of shared libraries in `libexec/bcftools` (plug-ins).
  * [bedtools 2](https://bedtools.readthedocs.io/en/latest/)
      * [Development on GitHub](https://github.com/arq5x/bedtools2)
      * Claims to use HTSlib since version 2.28, but it actually includes the necessary
        code and doesn't seem to have an option yet to include an existing HTSlib library.
        In fact, the version it includes is rather old and the code relies on features 
        of that old version that are not present in current versions anymore.
      * No configure or CMake, only a Makefile... It does have a ``make install prefix=...`
        though.
      * The build process creates a single executable, `bin/bedtools`, and a lot
        of shell scripts in the `bin` subdirectory, but no libraries or other files. 
  * [CD-HIT](http://weizhongli-lab.org/cd-hit/)
      * [Develpment on GitHub](https://github.com/weizhongli/cdhit)
      * MakeCp build process to ensure that we also install some files that are not
        done by `make install`.
      * The build process generates a number of binaries and a lot of Perl scripts, but no 
        libraries.
  * [ClonalFrameML](https://github.com/xavierdidelot/ClonalFrameML)
      * MakeCp build process.
      * The build process generates a single binary and a R script.
  * [fastp](https://github.com/OpenGene/fastp)
      * Just a make/make install build process, and several variables needed to get the
        compiler and optimizations right.
      * The build process generates a single executable.
  * [HTSlib](http://www.htslib.org/)
      * [Development on GitHub](https://github.com/samtools/htslib)
      * ConfigureMake build process.
      * The build process produces three binaries, a shared and a static library.
  * [MCL](http://micans.org/mcl/)
      * ConfigureMake, but there are two files that are not copied by the make install.
      * The build process generates several binaries, a bash and three Perl scripts, 
        but no libraries.
  * [MEGAHIT](https://github.com/voutcn/megahit)
      * CMakeMake
      * The build process only produces executables.
  * [miniasm](https://github.com/lh3/miniasm)
      * MakeCp, and needs some tricks.
      * The build process produces two executables
  * [Minimap2](https://github.com/lh3/minimap2)
      * MakeCp, and needs some tricks.
      * The build process produces three binaries and a static library.
      * Ancient: no multicore parallelism, SIMD support only up to SSE 4.1.
  * [MUSCLE](http://drive5.com/muscle/)
      * MakeCp, but does need a patch as the compiler name is hard-coded in the Makefile
        and not even in a variable that we can overwrite
      * Build process creates a single file, `bin/muscle`
  * [Racon](https://github.com/lbcb-sci/racon)
      * CMakeMake build process.
      * The build process only generates the executable `bin`racon`.
  * [SAMtools](http://www.htslib.org/)
      * ConfigureMake build process, but using an EasyBlock to install additional
        files that are not installed by `make install`.
      * Depends on HTSlib in this Bundle
      * SAMtools contains a number of binaries, a static libraries, several Perl 
        scripts but also two LUA scripts.
  * [VSEARCH](https://github.com/torognes/vsearch)
      * Autotools-based, but needs some preprocessing and configopts.
      * The build process generates a single executable


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




