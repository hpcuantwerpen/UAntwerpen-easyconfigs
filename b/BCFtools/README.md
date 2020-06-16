# BCFtools instructions

  * [BCFtools home page](https://www.htslib.org/)
  * [BCFtools development on GitHub](https://github.com/samtools/bcftools)
  * [BCFtools documentation](http://samtools.github.io/bcftools/)


## General information

  * BCFtools is part of the SAMtools suite. At some point, SAMtools was split in 
    the current SAMtools, HTSlib and BCFtools.
  * BCFtools dependencies
      * HTSlib
      * zlib
      * GSL: optional, for the `polysomy` command
      * libperl: optional, to support filters using perl syntax
  * BCFtools consists of a single binary, a number of Perl and Python scripts
    and a large number of shared libraries in `libexec/bcftools` (plug-ins).

## EasyBuild

There is [support for BCFtools in the EasyBuilders
repository](https://github.com/easybuilders/easybuild-easyconfigs/tree/develop/easybuild/easyconfigs/b/BCFtools)
which we used as a starting point.

### 1.10.2 for the 2020a toolchains

  * The EasyConfig was developed to prepare for inclusion in the BioTools bundle.
  * The optional Perl filters are currently disabled as it is not clear what is needed 
    to get them to work.