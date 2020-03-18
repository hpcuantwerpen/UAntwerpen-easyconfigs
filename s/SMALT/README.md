# SMALT installation instructions

* [SMALT web site @ Wellcome Sanger Institute](https://www.sanger.ac.uk/science/tools/smalt-0)
* [SMALT on SourceForge](https://sourceforge.net/projects/smalt/)

Note that SMALT is unmaintained since late 2014.

## Dependencies

* SMALT uses libz to read gzipped FASTA/FASTQ files as input.
* SMALT looks for SAMtools (or at least its library libbam.a). 
  However, it turns out that it needs an old, pre-1.0 version
  as the function it is looking for in the configure script,
  sam_open, has been replaced later on by samopen. However, the 
  variable HAVE_SAMTOOLS_API which is defined by the configure,
  is used nowhere in the code, so this appears to be a fake dependency,
  probably a leftover from old code, which is now replaced by the 
  next dependency.
* Optional dependency: [bambamc library](https://github.com/gt1/bambamc). This 
  library is unmaintained since May 2014.
* SMALT also includes a number of Python scripts in the subdirectory ``test``.
  These scripts are only examples and not executable (the lack the shebang).

## EasyConfig

The SMALT EasyConfig is based on one found in the EasyBuild 3.8.1 distribution.
Given that SMALT hasn't seen any decent update for years and nobody contributed newer
EeasyBuild recipes, support has disappeared in recent versions of EasyBuild.

### SMALT 0.7.6 with Intel 2019b.

* SMALT is installed as a bundle. We first install the bambamc library as a 
  static library and then install SMALT. Since bambamc is effectively just a
  build dependency for SMALT (as we create a static library) we remove it
  again after building SMALT to make sure we minimize interference between
  such old tools and newer tools in the toolchain.
* The regular build process of SMALT puts a number of test scripts (in Python)
  in the ``share`` subdirectory. We rename that directory to ``test`` and also
  copy the datafiles which were forgotten in the installation Makefiles.

