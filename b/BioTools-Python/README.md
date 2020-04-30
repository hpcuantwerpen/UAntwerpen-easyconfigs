# BioTools-Python instructions

BioTools-Python is a bundle with various Python packages for bio-informatics, 
often wrappers around tools included in the BioTools bundle.

## Included tools

* [biopython](https://biopython.org/) ([PyPi](https://pypi.org/project/biopython/)})
* [Flye](https://github.com/fenderglass/Flye)
    * Tricky since it can only be downloaded from GitHub with a meaningless filename
* [HTSeq](https://pypi.org/project/HTSeq/) ([Documentation](https://htseq.readthedocs.io/) 
  and [development on GitHub](https://github.com/htseq/htseq))
    * Uses Pysam
* [pysam]https://pypi.org/project/pysam/) ([homepage on GitHub](https://github.com/pysam-developers/pysam))
    * Can use HTSlib from BioTools only if versions match which is rarely the case,
      so by default we use the internal one.
* [SICER2](https://pypi.org/project/SICER2/) ([Homepage/documentation](https://zanglab.github.io/SICER2/))
    * Uses BEDTools, though I can't find how to indicate it during installation that
      BEDTools is available, so it might just use commands from BEDTools at runtime.

Packages that should be considered for total removal:
* [DLCpar](https://www.cs.hmc.edu/~yjw/software/dlcpar/)
    * Doesn't seem to be fully Python 3 compliant, I see problems in the install 
      log files.

Note that several of these tools use other tools, but rather than being able to use 
an existing version, include their own. Hence those tools may all behave differently 
as the dependencies may be compiled with different features enabled. Moreover, we cannot 
exclude that in the long run conflicts will arise if tools would also include the regular 
binaries and libraries of those tools they depend on.

## EasyConfigs

The EasyConfig was developed at UAntwerp.

One particular problem we had to cope with is Python packages that are not on PyPi 
but are downloaded from, e.g., GitHub. They may have names such as v%(version)s.zip
or even %(version)s.zip. The problem we have then is that in a Bundle or extension
list, all files of packages are stored together and the filenames might not be unique.

The root of the problem is that EasyBuild has a mechanism to download sources of
regular packages or of components of a bundle and rename them on the way to a more 
meaningful name, but has no such mechanism for extensions.

The solution we implemented consists of several components:
* We use Bundle as the main EasyBlock rather than PythonBundle, and set
  `exts_defaultclass = 'PythonPackage'` instead.
* We now also manually need to adjust `PYTHONPATH` in the EasyConfig.
* We still install all packages via the extension list mechanism simply because this 
  assures that they are all equally listed with version number in `module spider`.
  However, those of which we want to rename the downloaded file are "installed"
  through the components. This is a fake install though: We use the EasyBlock Tarball
  and skip the install step so that effectively nothing happens to the install
  directories.
