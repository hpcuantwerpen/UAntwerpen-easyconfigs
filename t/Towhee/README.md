# Towhee instructions

  * [Towhee web site](http://towhee.sourceforge.net/) is maintained on 
    [SourceForge](https://sourceforge.net/projects/towhee/).
      * [Code Manual](http://towhee.sourceforge.net/code/code_manual.html),
        useful when installing the code.
      * [Download from SourceForge](https://sourceforge.net/projects/towhee/files/)

## EasyConfigs

There was no official EasyBuild support when we first installed Towhee on our systems.
There was however a 
[EasyConfig file by ComputeCanada](https://github.com/ComputeCanada/easybuild-easyconfigs/tree/computecanada-master/easybuild/easyconfigs/t/TOWHEE).

### Towhee 8.2.0

  * The code violates the Fortran standard for fixed form source files. In `Source/ffdreiding.F`
    there is a line that is 74 characters long. The line shrinks when the preprocessor is applied,
    but a Fortran-zware preprocessor that neglects characters on position 73 and further as it should,
    will fail. This is the case with the Intel Fortran compiler. Most compilers have options to
    allow for longer source lines, but that might also fail as the code is linked with the C
    compiler but the options of the Fortran compiler are used. So when adding the flag required
    for longer source lines, the C compiler may not recognize that option and fail.
      * `-extend-source` worked in our case, but `-extend-source 80` or `-extend-source 132`
        did not because of problems while linking.

