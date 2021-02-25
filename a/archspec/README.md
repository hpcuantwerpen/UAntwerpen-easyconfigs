# archspec installation instructions

  * [archspec on GitHub](https://github.com/archspec/archspec)
      * [GitHub releases](https://github.com/archspec/archspec/releases/tag/v0.1.2)
  * [archspec documentation on ReadTheDocs](https://archspec.readthedocs.io/en/latest/)
  * [archspec on PyPi](https://pypi.org/project/archspec/)

## General information

  * archspec is developed in the context of Spack and later also used by EasyBuild and
    EESSI. It is Python code to detect the CPU architecture and features of that architecture
    and can even suggest the right options for several compilers to optimize for that
    architecture.
  * Archspec is very picky in the dependencies for a tool that should run at the level it
    does.

## Installing with EasyBuild

There is [support for archspec in the EasyBuilders repository]().

### Archspec 0.1.0 in Intel 2020a

We stuck to 0.1.0 even though 0.1.2 was out as it turnes out that later versions needed
newer versions of certain packages than we have installed in our Python module.

