# Pandoc installation instructions


## General

Pandoc depends on several other programs, especially for processing LaTeX and
generating PDF files. As we do not want to offer LaTeX on the clusters, the
functionality of Pandoc will be slightly limited.

We did chose to include groff and makeinfo and include Ghostscript as a dependency
to offer a different path for generating PDF to our users.

Pandoc is written in Haskell so would require installing a particular Haskell
environment also. Moreover, its build process uses tools that are not supported
by EasyBuild. Given that Pandoc should not be the time-critical part in a HPC code
it makes sense to install from binaries as otherwise getting all staps to work and
integrated in EasyBuild would take ages and require the development of a new EasyBlock
to support installing with the tool it uses (``stack``) which is not very compatible
with the way of working in an HPC system anyway.


## Easybuild

As some users certainly want to use Pandoc to generate PDF, we did add some additional
software to the Pandoc module in the EasyBuild repository.

  * There is [support for Pandoc](https://github.com/easybuilders/easybuild-easyconfigs/tree/main/easybuild/easyconfigs/p/Pandoc)
    in the EasyBuilders repository.
  * There is [support for makeinfo](https://github.com/easybuilders/easybuild-easyconfigs/tree/main/easybuild/easyconfigs/m/makeinfo)
    in the EasyBuilders repository.
  * There is [support for groff](https://github.com/easybuilders/easybuild-easyconfigs/tree/main/easybuild/easyconfigs/g/groff)
    in the EasyBuilders repository.

### Pandoc 2.11.4

  * We combined with makeinfo/texinfo 6.7 and groff 1.22.4 compiled in the GCCcore
    base toolchain. Hence Pandoc also lands in GCCcore even though it is simply installed
    from a tarball with binaries.
  * For some reason, the second component in the Bundle failed to find the installed files
    of the first one, so the path is set by hand. It is not clear what is happening here
    as there are other Bundle-based tools where things seem to go right. In the Baselibs bundle
    we have various tools that need other tools.
