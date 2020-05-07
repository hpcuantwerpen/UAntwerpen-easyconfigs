# SCons instructions

* [SCons web site](https://www.scons.org/)
* [SCons on GitHub](https://github.com/SCons/scons)
    * [Releases](https://github.com/SCons/scons/releases)
* [SCons on SourceForge](https://sourceforge.net/projects/scons/)
    * [Downloads on SourceForge](https://sourceforge.net/projects/scons/files/scons/)

## General information

* SCons is Python software
    * Version 3.1 (when this documentation was first written) Requires 2.7 or 3.5+

## EasyBuild

This documentation was written when installing version 3.1.2 in the 2020a
build round.

There is support for SCons in the [
EasyBuilders repository](https://github.com/easybuilders/easybuild-easyconfigs/tree/develop/easybuild/easyconfigs/s/SCons).
It however relies on EasyBuild-generated Python modules which is kind of stupid
for a tool that is used to install some very basic software.

### 3.1.2

* Developed with the goal of integrating into out buildtools module.
* Started from an EasyBuilders recipe.
* Switched to the SYSTEM toolchain and using a system-installed Python.
* Since we already had a package in the buildtools bundle that requires Python 3
  (Meson) we decided to go for Python 3. This implies:
    * Forcing EasyBuild to use the right Python executable by setting
      req_py_majver and req_py_minver.
    * Since the wrapper script use `/usr/bin/env python`, we edited them with
      sed to use `python3` instead to ensure that the right version of Python
      corresponding to the installed libraries is used. Otherwise we could
      expect conflicts with the PYTHONPATH in buildtools.
* Since our system Python does not have pip installed, we turned off pip 
  installation.
 