# IntelPython3 instructions

At UAntwerp, we do not install the Intel compilers using EasyBuild, but use the
Intel procedure. Hence the EasyConfig files in this directory are just dummies
used to create the module files.

Note that we only use the *.0x.eb files to install module files, and we put 
them in a directory of architecture-neutral files. The -yyyy[a|b].eb files
are only used within EasyBuild. For the modules we simply use symbolic links
to the appropriate *.0x module file.
