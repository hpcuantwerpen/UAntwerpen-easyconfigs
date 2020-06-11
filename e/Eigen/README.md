# Eigen instructions

  * [Eigen weg site](http://eigen.tuxfamily.org/)
  * [Eigen on GitLAb](https://gitlab.com/libeigen/eigen)
      * [Releases](https://gitlab.com/libeigen/eigen/-/releases)

## General information

  * Eigen is just a template library for C++. Hence the installation is completelhy compiler-neutral.
  * Eigen moved to GitLab at the end of 2019, so old EasyConfig files will no longer 
    succeed in downloading the files from BitBucket. The move was made because BitBucket
    dit no longer support mercurial, and if the had to switch to git, they decided 
    they could as well switch to another provider.
  * According to [the installation instructions](https://gitlab.com/libeigen/eigen/-/blob/master/INSTALL)
      * One can simply copy the `Eigen` subdirectory to any desired location.
      * There is also a CMake installation process. It does install some additional 
        files such as support for pkgconfig and for CMake. *That CMake process can 
        produce a lot of warnings, but they are really only relevant to those installing
        Eigen during the compilation process for an actual application, and not to 
        simply do a source install of Eigen.*

## EasyBuild

There is [support for Eigen in the EasyBuilders 
repository](https://github.com/easybuilders/easybuild-easyconfigs/tree/develop/easybuild/easyconfigs/e/Eigen).
The procedure might be more complicated then needed as a custom EasyBlock is used which 
given the simplicity of the installation process seems overkill.

### Version 3.3.7 for the 2020a toolchains.

  * Switched to downloading from GitLab.
  * Switched to installing in the system toolchain as there is nothing compiler-specific 
    about the whole package.



