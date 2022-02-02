# NEURON instructions

  * [NEURON home page](https://neuron.yale.edu/neuron/)

  * [NEURON on GitHub](https://github.com/neuronsimulator/nrn)

      * [GitHub releases](https://github.com/neuronsimulator/nrn/releases)


## EasyBuild

  * [NEURON in the EasyBuilders repository](https://github.com/easybuilders/easybuild-easyconfigs/tree/develop/easybuild/easyconfigs/n/NEURON)

  * NEURON does use [a software-specific EasyBlock](https://github.com/easybuilders/easybuild-easyblocks/blob/develop/easybuild/easyblocks/n/neuron.py).


### Version 7.2.2 in intel 2020a

  * This EasyConfig works on Vaughan, with the sanity check.

  * This EasyConfig does not work on the aurora node with CentOS 8. The
    sanity check hangs, and trying to import the Python neuron package
    by hand also hangs.
