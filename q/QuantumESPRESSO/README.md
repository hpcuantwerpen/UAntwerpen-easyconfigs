# QuantumESPRESSO instructions

  * [QuantumESPRESSO website](https://www.quantum-espresso.org/)
  * [QunatumESPRESSO development on GitLab](https://gitlab.com/QEF/q-e)
      * [Releases on GitLab](https://gitlab.com/QEF/q-e/-/tags)
  * [Mirror on GitHub](https://github.com/QEF/q-e)
      * [Releases on GitHub](https://github.com/QEF/q-e/releases)


## General information

  * The downloads of QuantumESPRESSO are a complete mess as different options use a 
    different directory structure and not all of them hence work with EasyBuild. Moreover, 
    the names change from time to time also.
      * The recommended download site accordint to the 
        [QuantumESPRESSO website](https://www.quantum-espresso.org/) is via 
        the [releases on GitHub](https://github.com/QEF/q-e/releases) which contain 
        two sets of files with different content and different directory names after 
        untaring.
          * Files with something like ReleasePack in their name (changes from version 
            to version)
          * The regular compressed tar and zip file from GitHub.
      * There are also [downloads on GitLab](https://gitlab.com/QEF/q-e/-/tags)

## Plug-ins

The working of QuantumEspresso can be extended greatly by adding plug-ins. Some of 
the plug-ins are in fact auto-downloaded by QuantumESPRESSO.

To find a list of recommended versions, check the `install\plugins_list` file. 
Some of those links will actually be transformed into a URL for a particular version
(certainly the case for d3q).

Note that this file may even contain invalid links. Installation of most plugins is 
not checked by the developers of QuantumESPRESSO. It depends on the work of individual
plugin maintainers and if they don't do their work, it may be that a package is shown
as a possible plugin but does not work anymore.

### QE-GIPAW

  * [QE-GIPAW development on GitHub](https://github.com/dceresoli/qe-gipaw/)
      * [Releases on GitHub - always use the version number corresponding to the QE
        version number!](https://github.com/dceresoli/qe-gipaw/releases/tag/6.5)


### d3q

  * [d3q development on SourceForge](https://sourceforge.net/projects/d3q/)
      * [Releases on SourceForge](https://sourceforge.net/projects/d3q/files/)
  * Versions are specific for versions of QuantumESPRESSO. Recent versions of 
    QuantumESPRESSO (certainly 6.4) auto-download this plug-in if its build is
    requested. To figure out the exact versions, check the releases on 
    SourceForge.


### wannier90

  * [wannier90 development on GitHub](https://github.com/wannier-developers/wannier90)
      * [Releases on GitHub](https://github.com/wannier-developers/wannier90/releases)
  * Compatible version: Check [`install/plugins_list`](https://github.com/QEF/q-e/blob/master/install/plugins_list)
    in the QuantumESPRESSO directories.


### PLUMED - *DROPPED*

  * [PLUMED web site](https://www.plumed.org/)
  * Support is only for outdated versions of QuantumESPRESSO via patching procedures
    provided by PLUMED. E.g., PLUMED 2.6, which was the current release of PLUMED when
    we started the development of this documentation in July 2020, supported 
    QuantumESPRESSO 5.0.2 and 6.2, while the then current version of QuantumESPRESSO
    was 6.5.


### WanNT - Wannier Transport - *DROPPED* 

  * [WanT web site](http://www.wannier-transport.org/)
  * Links on the web site are dead as QE-Forge does no longer exist. The official download
    site has disappeared. Hence we dropped this plugin from our installations.


### West - Without Empty STates - *DROPPED* 

  * [WEST web site](http://www.west-code.org/)
      * Releases on this site may be out-of-date.
  * [Main WEST development site on a private GitLab](http://greatfire.uchicago.edu/west-public/West)
      * [Releases](http://greatfire.uchicago.edu/west-public/West/-/tags)
  * [WEST development mirror on GitHub](https://github.com/west-code-development/West)
      * [Releases on GitHub](https://github.com/west-code-development/West/releases)
  * At the time of writing (July 2020), WEST only supports QuantumESPRESSO 6.1 even 
    though the WEST releases are much newer than that version of QuantumESPRESSO. Hence 
    it is dropped from recent installations at UAntwerp.


### Yambo - *DROPPED* 

  * [Yambo web site](http://www.yambo-code.org/)
  * [Yambo Wiki](http://www.yambo-code.org/wiki/index.php?title=Main_Page) contains
    the [installation instructions](http://www.yambo-code.org/wiki/index.php?title=Installation).
  * [Yambo development on GitHub](https://github.com/yambo-code/yambo)
      * [Releases on GitHub](https://github.com/yambo-code/yambo/releases/tag/4.5.0)
  * Even though we used to install older versions of Yambo in older versions of QuantumESPRESSO 
    (which required a patch) it is not clear if and how this can be done with newer versions of
    Yambo and QuantumESPRESSO. Hence we dropped support for Yambo in recent installations of
    QuantumESPRESSO at UAntwerp.
  * Yambo is also known to cause strange crashes with at least some versions of the Intel compilers.


## EasyBuild support

  * There is [support in EasyBuild for QuantumESPRESSO](https://github.com/easybuilders/easybuild-easyconfigs/tree/master/easybuild/easyconfigs/q/QuantumESPRESSO)
    which makes use of [an EasyBlock](https://github.com/klust/easybuild-easyblocks/blob/master/easybuild/easyblocks/q/quantumespresso.py).
  * There are often problems though using the EasyBlock. They are due to the different 
    downloads for QuantumESPRESSO with different directory structure, and the changes 
    in that structure between versions of QuantumESPRESSO that occur more often than 
    one would like. Also, it occasionally happens that the list of executables for 
    plugins encoded in the EasyBlock gets out-of-date, resulting in crashes during
    the sanity check.


### 2020a toolchains - QuantumESPRESSO 6.4.1 and 6.5 with EasyBuild 4.2.2.

  * The QuantumESPRESSO EasyBlock in EasyBuild 4.2.2 contains a bug in the list of 
    binaries for the d3q plugin. The `d3_import3py.x` is not included in d3q 1.1.4 
    or newer. Hence we needed to adapt the EasyBlock to avoid the sanity check
    failing.
  * 6.4.1:
      * Source file https://github.com/QEF/q-e/releases/download/qe-6.4.1/qe-6.4.1_release_pack.tgz
          * Builds in qe-6.4.1 (no further subdirectory).
  * 6.5: 
      * Source file https://github.com/QEF/q-e/releases/download/qe-6.5/qe-6.5-ReleasePack.tgz
          * Builds in qe-6.5 (no further subdirectory).
      * Note: Source file https://github.com/QEF/q-e/archive/qe-6.5.tar.gz or 
        https://gitlab.com/QEF/q-e/-/archive/qe-6.5/q-e-qe-6.5.tar.bz2: 
          * Builds in qe-6.5/q-e-qe-6.5
          * Fails during the install step as EasyBuild tries to copy from q-e-qe-6.5/bin
            instead of qe-6.5/q-e-qe-6.5.
          

