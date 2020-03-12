# NTPoly installation instructions

* [Homepage: William-Dawsun github.io](https://william-dawson.github.io/NTPoly/)
* [Electronic Structure Library github with EasyConfigs](https://github.com/ElectronicStructureLibrary/esl-easyconfigs)

## EasyConfigs

* The EasyConfigs are derived from those on the
  [Electronic Structure Library github](https://github.com/ElectronicStructureLibrary/esl-easyconfigs/tree/master/easyconfigs/n/NTPoly)
* We did make a change: By doing two iterations we build both static and shared libraries.
* Though NTPoly does use MPI, it does not need the ``'usempi': True`` in the toolchainopts.
  