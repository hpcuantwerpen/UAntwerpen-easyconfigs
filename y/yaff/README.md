# YAFF installation instructions

YAFF is software from the molmod research group at UGent. However, there is a
LAMMPS user module that uses it.

  * [Yaff documentation](https://molmod.github.io/yaff/index.html) - When I checked
    this page the documentation was for the [most recent version on PyPi](https://pypi.org/project/yaff/)
    but that one was older then the most recent one available on GitHug (see below).
  * [Yaff on GitHub](https://github.com/molmod/yaff)
      * [GitHub releases](https://github.com/molmod/yaff)

## EasyBuild

There is [support for yaff in the EasyBuilders repository](https://github.com/easybuilders/easybuild-easyconfigs/tree/master/easybuild/easyconfigs/y/yaff).

### Yaff 1.6.0 in the 2020a toolchains

  * Only installed with Python 3.8.3 as it was really installed for use with LAMMPS.
  * Started from the default EasyConfig, but changed the version of the ``molmod`` dependency
    to the one that was already installed and deleted the ``h5py`` dependency as that
    package is part of our standard Python module.
