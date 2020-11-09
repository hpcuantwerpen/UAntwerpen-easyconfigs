# ParaView installation

ParaView is an open source visualisation tool. Its developers are:
  * Sandia National Laboratories
  * Los Alamos National Laboratory
  * [Kitware](https://www.kitware.com/)


Links:
  * [ParaView web site](https://www.paraview.org/)
      * [ParaView Wiki](https://www.paraview.org/Wiki/Main_Page) on that web site
        also contains information about some other packages having the same
        origins and distributed by Kitware.
      * That Wiki also contains the [installation instructions](https://www.paraview.org/Wiki/ParaView:Build_And_Install),
        though this is an old text that refers to the 
        [building instructions on the ParaView GitLab server](https://gitlab.kitware.com/paraview/paraview/blob/master/Documentation/dev/build.md).
  * [ParaView GitLab](https://gitlab.kitware.com/paraview/paraview)
      * [build instructions](https://gitlab.kitware.com/paraview/paraview/blob/master/Documentation/dev/build.md)


## Architecture


  * Client side:
      * `paraview`: The GUI-application
      * `pvpython`: Python scripting interface for Paraview
  * Server side: 2 options also
      * `pvserver`: renderen and data server in one, MPI support to run on multiple nodes
      * `pvdataserver` and `pvrenderserver`: Separate data- and renderservers. This scenario is discouraged as it if often less efficient. It does allow to do data processing and rendering on separate sets of nodes, but that rarely delivers much performance gain.
  * `paraview` and `pvpython` have their own built-in dataserver and renderengine for local processing.
  * `pvbatch` finally is a Python interpreter designed for batch processing rather than interactive visualisation and can be run in parallel.


## Dependencies

  * ParaView needs Qt for the GUI component.
  * ParaView needs Python, as one of the ways of working with it is to use it as 
    a Python toolbox.
  * ParaView uses the OpenGL graphics drivers from the platform it is running on.
    If there is no hardware OpenGL support, one can use Mesa instead.
  * FFmpeg is an optional dependency to generate `.avi` movie files.
  * It is best if the Python package `six` is already installed.

## EasyBuild

There is [support for ParaView](https://github.com/easybuilders/easybuild-easyconfigs/tree/master/easybuild/easyconfigs/p/ParaView) in
the EasyBuilders repository.

### ParaView 5.4.1, Intel 2018a

  * Modified from the default EasyConfig files as we prefer to use system libraries for OpenGL
    trying to ensure that the OpenGL accelerator on the visualisation node can be used.
  * Python 2 and Python 3 version.

### ParaView 5.8.1

  * As we failed to compile Qt5 in the 2020a toolchains (with different errors depending on the
    compiler used and version of Qt5), the initial installation was in the 2018a toolchain.
  * We dropped support for also installing the data files and PDF copies of the tutorial.
    It is not clear if it even makes sense to include the data files as there was nothing
    about it in the install instructions, and the PDFs are not practical either on the 
    cluster but can better be downloaded by the user to his or her desktop environment.
