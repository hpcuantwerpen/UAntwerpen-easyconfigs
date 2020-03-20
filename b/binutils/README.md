# binutils instructions

* [GNU binutils web page](https://www.gnu.org/software/binutils/)
* [GNU binutils download](https://ftp.gnu.org/gnu/binutils/)

## EasyConfigs

### 2020a toolchains

* The toolchains are officially based on binutils 2.34 and GCC 9.3.
* The problem with binutils 2.33.1 and 2.34 is that it keeps trying installing the 
  documentation, even when ``makeinfo`` is not present on the system. This causes a 
  failure of the build process. The workaround was to define ``MAKEINFO=true`` in 
  buildopts and installopts.
