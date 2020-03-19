# PLUMED installation instructions

* [PLUMED web site](https://www.plumed.org/)
  * [PLUMED on GitHub](https://github.com/plumed/plumed2)

## General information

* Environment variables:
    * ``PLUMED_KERNEL`` is used by the Python wrappers when they are installed from 
      PyPi outside the regular PLUMED install process (which makes sense as this makes
      it easier to support multiple versions of Python). See, e.g.,
      [PLUMED manual: Installing Python wrappers](https://www.plumed.org/doc-v2.5/user-doc/html/_installation.html#installingpython-outside)
    * ``PLUMED_ROOT``: points to PLUMED-related source files that are used by various
      scripts that rely on PLUMED. This variable and the next ones are discussed on
      [The manual page "Installation Layout"](https://www.plumed.org/doc-v2.5/developer-doc/html/_installation_layout.html).
    * ``PLUMED_INDLUDEDIR``: Points to the include files.
    * ``PLUMED_HTMLDIR``: Points to the HTML documentation in share/doc/plumed, but 
      these files are not installed by the current EasyConfigs. (We don't run 
      ``make doc``)
    * ``PLUMED_PROGRAM_NAME``:  usually plumed.
    

## EasyConfigs

First version covered by this documentation: The 2019b toolchains.

### 2019b toolchains: 2.4.7, 2.5.4, 2.6.0

* Switched from modextrapaths to modextravars, as PLUMED_ROOT and PLUMED_KERNEL
  shouldn't be treated as paths if the variables already exist when the module
  is loaded. We also added other relevant variables.
