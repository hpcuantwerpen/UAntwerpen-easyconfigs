# ScaFaCos installation instructions

ScaFaCoS is a library of scalable fast coulomb solvers used by LAMMPS.

  * [ScaFaCos web site](http://www.scafacos.de/)
  * [ScaFaCos on GitHub](https://github.com/scafacos/scafacos)
      * [GitHub releases](https://github.com/scafacos/scafacos/releases)

## EasyBuild

There is [sopport for ScaFaCos in the EasyBuilders repository](https://github.com/easybuilders/easybuild-easyconfigs/tree/master/easybuild/easyconfigs/s/ScaFaCoS).

### Version 1.0.1 in intel 2020a

  * Installed as a dependency of LAMMPS
  * Regular EasyConfig edited to use our ``buildtools`` and ``baselibs`` modules,
    brought in line with our style and with updated help text for the module file.
