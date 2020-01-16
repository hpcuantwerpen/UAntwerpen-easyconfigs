# GATK 3 installation instructions

GATK 3 is no longer supported by the Broad Institute. 

Information on GATK3 is [archived on GitHub in broadgsa/gatk-protected](https://github.com/broadgsa/gatk-protected).
It also contains the [GATK 3 documentation archive](https://github.com/broadgsa/gatk-protected/tree/master/doc_archive).
The repository also contains the releases. The files that can be found there
are the sources though and have a different content from the files that are
used by the EasyConfigs for pre-4.0 versions. It is still possible to download
the regular install files from 
[https://software.broadinstitute.org/gatk/download/archive](https://software.broadinstitute.org/gatk/download/archive)
which will redirect to the Google Cloud.

It is not clear to which extent the EasyConfig included in this directory is still
OK. GATK 4 relies on several Python and R-packages; it is not clear if and to which
extent these are also needed for GATK 3.

Included EasyConfigs:
* GATK-3.7-Java-8.eb: To install from a release file as could be downloaded from the
  Broad Institute web site before GATK 3 was archived.
* GATK-3.8-1-Java-8.eb: To install from the files that can be found in the archive
  mentioned above. The "resources" directory is not present in those archives, only
  the jar-file is.

# GATK 4 installation instructions

Most if not all EasyConfigs from the EasyBuilders site for GATK 4 are basically 
junk (recipes up to GATK-4.1.3.0-GCCcore-8.3.0-Java-1.8.eb were checked). They claim
to do a full install yet do only a very partial install of GATK. The only Python script
that is installed is the wrapper script `gatk` which will probably even run with most
system Python binaries. The included Python packages are never installed. Hence the `multi_deps`
line that is included in the file is basically useless. Its only function is that the
module help information will contain a line telling the user to load a Python module.

GATK 4.1 has a number of dependencies:
* R is used by some tools in GATK for producing graphics. A list of R packages is 
  included in the [script instal_R_packages.R](https://github.com/broadinstitute/gatk/blob/master/scripts/docker/gatkbase/install_R_packages.R)
  in the directory `scripts/docker/gatkbase' of the 
  [GATK GitHub repository](https://github.com/broadinstitute/gatk). That script is
  not included in the distribution file used by the EasyConfig files. It is not clear
  if that script also includes all dependencies of those packages, so it may still
  require some puzzling to translate that list into an EasyBuild recipe.
* Several Python packages are used by various tools included in GATK, including
  machine learning packages such as `Keras` and `TensorFlow`. A list of packages
  can be found in the Conda configuration file `gatkcondaenv.yml` included in the
  distribution or in [the file gatkcondaenv.yml.template](https://github.com/broadinstitute/gatk/blob/master/scripts/gatkcondaenv.yml.template)
  in the subdirectory `scripts` of the [GATK GitHub repository](https://github.com/broadinstitute/gatk).

## Minimal installation of GATK

In the minimal installation we don't include any of the dependencies mentioned above,
not installed in the software directory nor through including them in module 
dependencies.

The EasyConfigs for the minimal installation were developed starting from a then
recent recipe in the EasyBuilders repository. We did make a number of changes though:

* As the code is mostly Java and a Python script that probably runs with any recent
  system Python, we moved the package to the dummy/SYSTEM toolchain. The user can then
  still load a more appropriate Python from any toolchain without us having to create
  a different module for every toolchain.
* Based on the `gatk` script and the 
  [file `Dockerfile`](https://github.com/broadinstitute/gatk/blob/master/Dockerfile)
  in the root directory of [the GitHub repository](https://github.com/broadinstitute/gatk)
  two additional variables were defined:
  * `GATK_LOCAL_JAR` points to the `gatk-package-<version>-local.jar` file and ensures the
    `gatk` wrapper quickly finds the file
  * The docker file defines `GATK_JAR` for that function. We cannot find that variable
    anywhere else, but just to be sure we do define it in the same way as `GATK_LOCAL_VAR`.
* As we cannot support Spark on the UAntwerp clusters, the file
  `gatk-package-<version>-spark.jar` is removed.
* The files in `gatkPythonPackageArchive.zip` are unzipped to the `python` subdirectory 
  and we add this directory to `PYTHONPATH`. It is not clear at this time though if this
  is enough to get these scripts working. One may have to run the included setup scripts.
  Moreover, contrary to what the GATK web site claims, at least Python 3.4 is required.
  Older versions of Python may be good enough for the `gatk` wrapper script but do not
  work with the newer Python components of GATK 4.

Included EasyConfigs:
* GATK-4.1.4.1-Java-8-minimal.eb
  