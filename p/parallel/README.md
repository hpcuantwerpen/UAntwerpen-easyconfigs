# GNU parallel instructions

* [GNU parallel web site](http://savannah.gnu.org/projects/parallel/)
    * [Check version](https://ftp.gnu.org/gnu/parallel/)
* [GNU parallel on gnu.org](https://www.gnu.org/software/parallel/)
* [git repository on GNU git](http://git.savannah.gnu.org/cgit/parallel.git)
* [GNU parallel tutorial](https://www.gnu.org/software/parallel/parallel_tutorial.html)

## General information

* GNU parallel is just a bunch of Perl scripts. There are no compiled binaries.

## EasyBuild

There is [support for parallel in the EasyBuilders repository](https://github.com/easybuilders/easybuild-easyconfigs/tree/develop/easybuild/easyconfigs/p/parallel).

The EasyBuilders recipes rely on a Perl build in the toolchain.

At UAntwerp, we have chosen to use the OS-provided perl distribution instead as
this seems to be sufficient to run GNU parallel. We also put more documentation
in our module files.
