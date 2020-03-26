# netCDF @ UAntwerp

The netCDF libraries are distributed in several packages:
* netCDF-C is the core library and contains the C API. ([Project on GitHub](https://github.com/Unidata/netcdf-c))]
* netCDF-Fortran: Fortran wrappers ([Project on GitHub](https://github.com/Unidata/netcdf-fortran))
* netCDF-4 C++: C++ wrappers, version 4 (the current C++ API) ([Project on gitHub](https://github.com/Unidata/netcdf-cxx4))
* netCDF-3 C++: The legacy C++-API, included for as long as it still works ([Download 
  site](https://www.unidata.ucar.edu/downloads/netcdf/index.jsp))

Moreover, several back-ends can be added to the netCDF package
* [HDF5](https://www.hdfgroup.org/solutions/hdf5/) is the back-end for 
  the newest netCDF file format. Parallel access
  will be enabled if the HDF5 library supports this.
* [PnetCDF](https://parallel-netcdf.github.io/) is a back-end for parallel 
  access when using some of the older netCDF file formats.

## EasyConfigs

The installation at UAntwerp differs from the default EasyBuild way of installing
netCDF. All necessary components except HDF5 are combined in a bundle as the
libraries are meant to be installed together in a single directory. Our vision
at UAntwerp is that it is worse to have longer search paths for binaries, libraries 
and include files than it is to have a few library files in the search path that a 
package may not need. Shorter module lists are also a benefit to users.

For this, we've been using bundles since the 2016b toolchains. However, initially they 
only included the C, Fortran and C++ interfaces but not the PnetCDF back-end.

### 2019b toolchains - netCDF 4.7.0

* From the 2019b toolchains on we do a MPI and a non-MPI build.
    * The MPI build includes the PnetCDF back-end and uses a HDF5 module explicitly 
      compiled with MPI (and MPI-IO) support.
    * The non-MPI version does not include the PnetCDF back-end and uses a HDF5
      module compiled without support for MPI. This one is safer to use in non-MPI 
      applications as with some MPI implementations a program compiled with libraries
      that use MPI may hang when started without mpiexec/mpirun depending on how the
      environment is set up.

### 2020a toolchains - netCDF 4.7.3

* Since it looks like older versions can no longer be downloaded from the UniData site,
  we switched to downloading from the GitHub for netCDF-C, netCDF-Fortran and netCDF4-CXX.
  This makes it easier to test with older versions if the newest version doesn't configure
  or compile correctly.
* Probably already present before: I noticed that LD_LIBRARY_PATH etc are not set in 
  the proper way in the bundle, refering to a non-existen lib64 directory rather than
  to lib. Hence we set LD_LIVRARY_PATH, LIBRARY_PATH and to be sure CFILES also in
  the preconfigopts, prebuildopts and preinstallopts.
* We made the switch to HDF5 1.10 but skipped 1.12 for now.
* netCDF-Fortran 4.5.2 ran into configure problems so we stuck to 4.4.5, the last release
  in the 4.4.x series.
* It was necessary to set parallel to 1 for building the Fortran interfaces as we observed
  compile errors that seemed random.

