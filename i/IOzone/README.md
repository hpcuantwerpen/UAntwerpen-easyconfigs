# IOzone EasyConfig

This EasyConfig is derived from the standard EasyBuilders EasyConfig.

As it really spends time doing I/O, it is simply compiled with the system compiler.

## Notes

* IOzone uses by default rsh to start processes on other nodes, which typically will
  not work on clusters. This is solved by setting the environment variable 
  `RSH` to `ssh` which we do in the module file to avoid user error.
