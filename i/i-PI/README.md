# i-PI instructions

i-PI is pure Python code, but it does have a number of Python dependencies
that are not part of our standard Python modules.

It is meant to be used with various computational chemistry packages, such as CP2K.

  * [i-PI web site](http://ipi-code.org/)
      * [Manual of the latest version](http://ipi-code.org/assets/pdf/manual.pdf)
  * [i-PI on GitHub](https://github.com/i-pi/i-pi)
      * [GitHub releases](https://github.com/i-pi/i-pi/releases)
  * [i-PI and CP2K](https://www.cp2k.org/tools:ipi)

## EasyConfigs

No support for i-PI was found in the EasyBuild distribution (version 4.3.2 at time
of first install).

### Version 2.3.0 in the 2020a toolchain

  * Installed for Python 3.8.3.
  * The dependencies were first checked by checking the requirements.txt file
    and installing them manually via ``pip`` , to also find the dependencies
    of dependencies and to ensure that all are installed properly.
