# Jmol instructions

Links:
* [Jmol web site](http://jmol.sourceforge.net/) (and this page can be accessed as 
  [www.jmol.org](http://www.jmol.org/) also)
* [Jmol documentation](http://jmol.sourceforge.net/docs/) is integrated on the web site. 
  At this time (December 2019) the link to the Wiki []wiki.jmol.org](http://wiki.jmol.org/index.php/Literature) 
  does not work.
* [Actual repository on SourceForge](https://sourceforge.net/projects/jmol/)
* Somewhere in the SourceForge pages it is said that development is moving to
  [GitHub](https://github.com/BobHanson/Jmol-SwingJS).

From the summary page on SourceForge: *Jmol/JSmol is a molecular viewer for 3D chemical 
structures that runs in four independent modes: an HTML5-only web application utilizing 
jQuery, a Java applet, a stand-alone Java program (Jmol.jar), and a "headless" server-side 
component (JmolData.jar). Jmol can read many file types, including PDB, CIF, SDF, MOL, PyMOL 
PSE files, and Spartan files, as well as output from Gaussian, GAMESS, MOPAC, VASP, CRYSTAL, 
CASTEP, QuantumEspresso, VMD, and many other quantum chemistry programs. Files can be 
transferred directly from several databases, including RCSB, EDS, NCI, PubChem, and 
MaterialsProject. Multiple files can be loaded and compared. A rich scripting language and 
a well-developed web API allow easy customization of the user interface. Features include 
interactive animation and linear morphing. Jmol interfaces well with JSpecView for spectroscopy, 
JSME for 2D->3D conversion, POV-Ray for images, and CAD programs for 3D printing (VRML export).*

However, since the login and visualisation nodes of our cluster are not meant to offer 
web services, the EasyConfig files in this repository only install the stand-alone 
Java program and "headless" component JmolData.jar. The shell scripts to start Jmol
are also included.
