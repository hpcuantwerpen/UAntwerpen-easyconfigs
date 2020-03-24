# Wannier90 install instructions

* [Wannier90 web site](http://www.wannier.org/)
* [Wannier90 on GitHub](https://github.com/wannier-developers/wannier90)

## General instructions

* Wannier90 has no configure script. Options are set by copying one of 
  files in config to make.inc and editing that file.

## EasyConfigs

The first version covered by this documentation is 3.1.0.

### 3.1.0 for Intel 2020a

* We started from the MakeCp-based file for 3.0.0 in the EasyBuilders
  repository. That recipe however doesn't work properly as not all executables
  that are generated during the build process are copied to the bin directory.
  In version 3.2.0 there is a install make target which is why we decided to
  switch to a ConfigureMake-based recipe skipping the configure step.
* We also removed the patch and instead create an empty make.inc file via
  ``prebuildopts``. Patches may need to be rewritten for new versions if the
  Makefiles change while this procedure has more chance to continue working.
  We do need to check which variables need to be defined though, but this was
  also the case with the patch.
* As there is no configure step, we do need to define the PREFIX in the install
  step.
