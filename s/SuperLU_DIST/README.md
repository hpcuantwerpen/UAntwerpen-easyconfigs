# SuperLU_DIST installation instructions

SuperLU_DIST is the distributed memory version of the SuperLU solver.

* [SuperLU home page](https://portal.nersc.gov/project/sparse/superlu/)
* [SuperLU_DIST GitHub](https://github.com/xiaoyeli/superlu_dist)

## EasyConfig

The development of the EasyConfigs is based upon those of the
[Electronic Structure Library github](https://github.com/ElectronicStructureLibrary/esl-easyconfigs/tree/master/easyconfigs/s/SuperLU).

Instead of using the patches they use there to use the Metis/parMetis 
compatibility interface of SuperLU, we simply reinstalled the necessary
header files in the SCOTCH include dirs (removed there by the SCOTCH
EasyBlock) and can then compile SuperLU without additional patches, at least
if no Metis or parMetis module is loaded which may conflict with those
header files.

For the 2020a toolchains, we switched to downloads from the GitHub.
