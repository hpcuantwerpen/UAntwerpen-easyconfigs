# ELSI installation instructions

ELSI provides and enhances scalable, open-source software library solutions for 
electronic structure calculations in materials science, condensed matter physics, 
chemistry, and many other fields. ELSI focuses on methods that solve or circumvent 
eigenvalue problems in electronic structure theory. The ELSI infrastructure should 
also be useful for other challenging eigenvalue problems.

* [Electronic Structure Library website]https://wordpress.elsi-interchange.org/)
* [Electronic Structure Library github with EasyConfigs](https://github.com/ElectronicStructureLibrary/esl-easyconfigs)

## Dependencies

ELSI interfaces to several eigensolvers and linear algebra packages.
* [ELPA](https://elpa.mpcdf.mpg.de/) - included with the distribution of ELSI, but 
  can use an external one.
* [LibOMM](https://esl.cecam.org/LibOMM) - included with the distribution of ELSI, 
  but can use an external one
* [PEXSI](https://pexsi.readthedocs.io/en/latest/) - included with the distribution 
  of ELSI
* [EigenExa](https://www.r-ccs.riken.jp/labs/lpnctrt/en/projects/eigenexa/) - should
  be included with the distribution of ELSI?
* [SLEPc-SIPs](https://slepc.upv.es/), based on PETSc - included with the distribution 
  of ELSE
* [NTPoly](https://william-dawson.github.io/NTPoly/) - included with the distribution 
  of ELSI, but can use an external one
* [BSEPACK](https://sites.google.com/a/lbl.gov/bsepack/) - included with the distribution 
  of ELSI, but can use an external one. BSEPACK development seems dead since 2015.
* [LAPACK](https://www.netlib.org/lapack/)
* [MAGMA](https://icl.utk.edu/magma/) linear algebra library for GPUs
* SuperLU_dist - included with the distribution of ELSI for PEXSI, but should use an 
  external one if an external PEXI is used
* PT-SCOTCH - included with the distribution of ELSI for SuperLU, but should use an 
  external one  if an external PEXI is used.

## EasyConfigs

### ELSI-2.5.0-intel-2019b

<table>
<tr><th>Library               </th><th>Version          </th></tr>
<tr><td>ELPA                  </td><td>2019.11.001      </td></tr>
<tr><td>LibOMM                </td><td>Internal         </td></tr>
<tr><td>PEXSI                 </td><td>Internal         </td></tr>
<tr><td>EigenExa              </td><td>Not included     </td></tr>
<tr><td>SLEPc-SIPs            </td><td>Not included     </td></tr>
<tr><td>NTPoly                </td><td>2.4              </td></tr>
<tr><td>BSEPACK               </td><td>Internal         </td></tr>
<tr><td>BLAS/LAPACK/ScaLAPACK </td><td>Intel toolchain  </td></tr>
<tr><td>MAGMA                 </td><td>Not included     </td></tr>
<tr><td>SuperLU_dist          </td><td>Internal         </td></tr>
<tr><td>PT-SCOTCH             </td><td>Internal         </td></tr>
</table>

* Compiling with EigenExa resulted in compilation error messages.
* Compiling with SIPS support resulted in compilation error messages.
* Despite some versions of the documentation claiming otherwise, there is no switch 
  ``USE_EXTERNAL_SUPERLU``. Using an external one only makes sense anyway if PEXSI is also
  external (as this is the part of the code that needs SuperLU). Checking the 
  CMakeLists.txt file learns that if PEXSI is external, SuperLU_DIST and SCOTCH 
  are also assumed to be external.
* We currently use the internal PEXSI as it takes a lot of time to install an external 
  one. PEXSI uses [symPACK](https://github.com/symPACK/symPACK) which relies on the
  [Berkeley UPC++ 1.0 library](https://bitbucket.org/berkeleylab/upcxx/). The links
  mentioned on the PEXSI site are dead, but the above ones are likely correct. 
