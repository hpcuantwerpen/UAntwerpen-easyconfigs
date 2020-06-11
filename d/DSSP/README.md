# DSSP instructions

DSSP is a program that can be called from GROMACS but is not integrated in GROMACS 
in any other way.

  * [DSSP web site](https://swift.cmbi.umcn.nl/gv/dssp/)
      * There is an [old download page](ftp://ftp.cmbi.ru.nl/pub/software/dssp/) on 
        a related server at that institution, but those versions are not up-to-date
        anymore.
  * [DSSP GitHub](https://github.com/cmbi/dssp)
      * [GitHub releases](https://github.com/cmbi/dssp/releases)

Note that we use the GitHub as source for the releases.

## General instructions

  * DSSP has moved to a ConfigureMake process.
  * For use with GROMACS, the environment variable DSSP needs to point to the executable
    (Google for GROMACS 2020 DSSP to find the relevant information in the GROMACS manual).
    It looks like GROMACS 2020 (the current version when writing this text) still requires
    the DSSP 2.x branch.
  * Dependencies
      * Boost (optional)
      * Claims to use libz, but no reference found in the code or link line though 
        configure checks for it.
      * Claims to use libbz2, but no reference found in the code or link line though 
        configure checks for it.

## EasyConfigs

There is no support for DSSP in the EasyBuilders repository.

### Version 2.2.1 for Intel 2017a

  * Old EasyConfig, from before switch to autoconf, with a Makefile patch to make it
    compatible with EasyBuild. The patch could have been better in retrospect.

### Version 2.3.0 for Intel 2020a

  * Still installed because it seems that even GORMACS 2020 still needs the version 
    2.x DSSP syntax. 
  * There is now a full configure process which we use in the EasyConfig.
  * The configure script does not correctly install the man page, so we copy it
    in postinstallcmds.
    

### Version 3.1.4 for Intel 2020a

  * Ported from the 2.3.0 EasyConfig. The same problems are present here. In fact, 2.3.0 
    was released later than 3.1.4 and it is likely the whole configure process was
    simply backported to that version.
