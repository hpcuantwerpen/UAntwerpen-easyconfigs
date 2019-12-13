# ASE installation notes

ASE stands for Atomic Simulation Environment. 

The Atomic Simulation Environment (ASE) is a set of tools and Python modules 
for setting up, manipulating, running, visualizing and analyzing atomistic 
simulations. The code is freely available under the GNU LGPL license.

* [ASE web site](https://wiki.fysik.dtu.dk/ase/)
* [ASE on PyPI](https://pypi.org/project/ase/)

## Dependencies

ASE needs a number of other Python packages:
* [NumPy](https://pypi.org/project/numpy/) - Included in the standard UAntwerp Python 
  bundles
* [SciPy](https://pypi.org/project/scipy/) (See also 
  [SciPy.org](https://www.scipy.org/)) - Included in the standard UAntwerp Python bundles
* [matplotlib](https://pypi.org/project/matplotlib/), at least version 2.0.0 
  (status for ASE 3.18.1) - Included in the standard UAntwerp Python
* tkinter, the TK interface, is a standard component of recent Python distributions.
* [Flask](https://pypi.org/project/Flask/) needs to be installed. It brings with it a set of other dependencies: 
    * [Werkzeug](https://pypi.org/project/Werkzeug/)
    * [Jinja2](https://pypi.org/project/Jinja2/), and this one needs
        * [MarkupSafe](https://pypi.org/project/MarkupSafe/)
    * [itsdangerous](https://pypi.org/project/itsdangerous/)
    * [click](https://pypi.org/project/click/) - Included in recent standard Python packages at UAntwerp, but not in some of
      the older ones.
Some of these packages have other dependencies that are included in the standard
UAntwerp Python bundles.

## EasyConfig

Nothing special here. We've chosen to install ASE together with all missing
dependencies through a "Bundle" EasyConfig. This does imply that we need to 
set `PYTHONPATH` by hand.

## Checking the build result

* Search in the EasyBuild log file for `python setup` to see if the compilation
  did not produce errors. Some packages have Python fallback code if the compilation
  fails, so the standard EasyBuild sanity check will not detect these problems,
  but the result will be a much slower Python package.

