# CD-HIT instructions

  * [CD-HIT home page](http://weizhongli-lab.org/cd-hit/)
  * [CD-HTI documentation site](https://github.com/weizhongli/cdhit/wiki)
  * [CD-HIT on GitHub](https://github.com/weizhongli/cdhit)
      * [Releases](https://github.com/weizhongli/cdhit/releases)
  

## General information

  * CD-HIT has no configure procedure. There is a `make install` in more recent versions, 
    but that does not install the documentation.
  * CD-HIT supports OpenMP parallelism but no distributed computing.
  * CD-HIT consists of a number of binaries in the `bin` subdirectory and a lot of 
    Perl scripts, but no libraries.


## EasyBuild

There is [support for CD-HIT in the EasyBuilders 
repository](https://github.com/easybuilders/easybuild-easyconfigs/tree/develop/easybuild/easyconfigs/c/CD-HIT).

We did make a couple of changes though to embed into our BioTools module.

### CD-HIT 4.8.1 for Intel 2020a BioTools

  * Moved the editing of the path to the Perl binary in the Perl scripts to `prebuildopts`. 
    This is a hack, but we don't really like messing around with postinstallcmds in a Bundle 
    as would be the case when integrating into BioTools.
  * Moved the content of doc to share/doc/CD-HIT.
  * Put the README file and the license.txt file also in share/doc/CD-HIT.
  * Note that adding 'openmp=yes' to the make command line is not needed as we include 
    the flag to compile for OpenMP in CCFLAGS. We add it by hand as in the Bundle `openmp`
    will not be set to `True`.
  * Even though there is a install target in the Makefile of version 4.8.1, we still 
    use the MakeCp EasyBlock it avoid having to use postinstallcmds or a clumsy setup
    of installopts to also copy the documentation.
  * Corrected two problems with the sed command to change the shebang.
     * The replace string was simply wrong as it omitted the `#!`.
     * Some files call perl with the `-w` flag and somehow that caused problems when using
       `#!/usr/bin/env perl -w`. We simply omit the `-w` flag as it is just to warn for
       errors in the code and hence more for code developers, and replaced by other mechanisms
       in modern Perl anyway.
