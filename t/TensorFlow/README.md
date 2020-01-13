# TensorFlow installation notes

## Problems encountered

### 2019b toolchains, Intel-compiled Python 3.7.4, Tensorflow 1.15.0 - 2.1.0

* Dependency astor: Version 0.8.1 does not work (fails during the sanity check); version 
  0.8.0 passes the tests.
* Dependency grcpio: 
    * Version 1.25.0 and 1.26.0 do not compile with the Intel compiler (the 
      compiler complains about a statement mixing vector and scalar computations). 
      1.24.3 is the last version that installs without problems.
      The fatal error actually happens in included third-party code, the boringssl
      crypto library. [Boringssl](https://boringssl.googlesource.com/boringssl) is 
      yet another piece of Google junk (an OpenSSL fork) that only compiles with 
      compilers that Google likes and not with others.
    * Checking the [gRPC GitHub](https://github.com/grpc/grpc) suggests
      that they do test the code with Clang, so there is hope for the future.
* Keras-metrics, added in earlier TensorFlow installations with Keras, doesn't
  work with the Keras 2.3.x - TenserFlow 1.15 or later combinations. Hence it is
  removed from our installation.
* Note that Keras 2.3.x is the last version of the multi-backend Keras implementation.
  Keras is now implemented directly in TensorFlow. However, using it that way does
  require changes to the code so we decided to keep Keras 2.3 in the TensorFlow modules
  for 1.15 and 2.1.

Since compiling TensorFlow is difficult, we went for binaries that were readily available.
We now get them from PyPi, which contains 4 different versions of TensorFlow
* [tensorflow](https://pypi.org/project/tensorflow/): For versions 1.14 and earlier 
  and 2.0, this is a version compiled for CPU. For 1.15.0 and 2.1.0 (and likely later
  versions) the binaries support both GPU and CPU. It is not clear to what extent the
  GPU binary is optimized for the P100. The CPU version contained in the module does not
  yet seem to use AVX2/FMA as available on our Broadwell and AND Rome nodes.
  Note also that it was tricky to find out which versions of CUDA and cuDNN and of 
  TensorRT (TensorFlow 2.1.0 only) were used to generate the binaries, and the major
  version numbers need to be correct for TensorFlow to find the libraries.
* [tensorflow-gpu](https://pypi.org/project/tensorflow-gpu/): TensorFlow compiled for
  use with NVIDIA GPUs. It is not clear to what extent the binaries are optimized for 
  the P100. As for the regular tensorflow package, some reverse engineering is required 
  to find the correct NVIDIA libraries.
* [tensorflow-cpu](https://pypi.org/project/tensorflow-cpu/): CPU-only binaries for 
  those versions of TensorFlow for which the tensorflow package contains a BPU/CPU 
  combined binary. The same remarks with respect to optmization hold as for the regular
  tensorflow package.
* [intel-tensorflow](https://pypi.org/project/intel-tensorflow/): This package is compiled 
  to use the Intel MKLDNN libraries for better performance on mondern Intel CPUs (and likely
  give some advantages on AMD Rome also).

For the 2019b toolchains, we created the universal and -gpu modules for TensorFlow 
1.15.0 and 2.1.0, and Intel-optimized once for TensorFlow 1.15.0 and 2.0.0 as the 2.1.0 
binaries of the latter were not yet available when we first did the installation.

