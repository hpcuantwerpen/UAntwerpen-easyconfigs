# MEGAHIT installation instructions

* [MEGAHIT on GitHub](https://github.com/voutcn/megahit)
* [MEGAHIT on the Metagenomics wiki](http://www.metagenomics.wiki/tools/assembly/megahit)

## General information

* MEGAHIT is mostly C/C++ code, but the script that starts the code is written in Python. 
  It does seem to work with the standard system Python though.
* MEGAHIT has a built-in test: after loading the module, run ``megahit --test``. 

## EasyConfigs

There is support for MEGAHIT in the EasyBuilders tree.

### 1.2.9 for intel 2019b and 2020a

* We started from a standard EasyBuild recipe for GCCcore but compiled with the Intel 
  compiler.
* The standard script does contain a multideps to load the Python module. Since the 
  code does not install any packages, its only function is to load a default Python 
  version and to print information about compatible Python modules. Since on our system
  the megahit script works fine with the system Python, we outcommented that line
  and instead give some information in our the usage field.
* Tested by running ``megahit --test`` which runs MEGAHIT on a toy dataset.
* 2020a: Moved ot the BioTools bundle
