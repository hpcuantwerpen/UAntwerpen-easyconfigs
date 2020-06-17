# Pysam installation instructions

* [pysam development on GitHub](https://github.com/pysam-developers/pysam)
* [pysam on PyPi](https://pypi.org/project/pysam/)
* [pysam documentation](https://pysam.readthedocs.io/en/latest/)

The goal of this recipe is to prepare for inclusion in the BioTools-Python bundle. However,
it turns out that linking to external HTSlib/BCFtools/SAMtools is difficult as pysam 
is often lagging in the versions supported.

There is no naming conflict with shared libraries though so it is perfectly possible 
to use the pysam Python module while another version of SAMtools/BCFtools/HTSlib is 
loaded.
