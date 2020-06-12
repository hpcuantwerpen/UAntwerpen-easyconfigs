# NetPyNE instructions

 * [NetPyNE home page](http://www.netpyne.org/)
 * [NetPyNE on PyPi](https://github.com/Neurosim-lab/netpyne)
 * [NetPyNE development on GitHub](https://github.com/Neurosim-lab/netpyne)

## General information

 * NetPyNE is a Python package as its name suggests. It is pure Python code; there 
   is no compilation of compiled languages taking place during installation.
 * A GUI is under development in a separate package (NetPyNE-UI) that also needs
   NEURON. It is based on Jupyter.

## EasyBuild

There is no EasyBuilders support for NetPyNE.

### 0.9.6 for Intel 2020a

  * Build on top of our Python 3.8.3 distribution and IntelPython3. The installation
    on our Python 3.8.3 module succeeds but it is not clear if the module will actually
    work as the `setup.py` script claims it only supports up to Python 3.7.
