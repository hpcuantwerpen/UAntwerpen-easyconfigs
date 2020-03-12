# SCOTCH installation remarks

* SCOTCH is installed via an EasyBlock. Most options are set through
  the toolchainopts. 
* The EasyBlock has a very nasty side effect. The author thought it was a
  bad idea to install the metis.h and parmetis.h files that are needed 
  to use the Metis/parMetis compatibility interfaces of SCOTCH. But these
  files are really needed if one want to compile a package with SCOTCH
  through those interfaces. E.g., to have SCOTCH support in SuperLU which
  is advised for big matrices. So we put these files back through 
  postinstallcmds.
