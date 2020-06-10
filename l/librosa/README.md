# librosa instructions

  * [librosa on PyPi](https://pypi.org/project/librosa/)
  * [librosa documentation](https://librosa.github.io/librosa/#)
  * [librosa on GitHub](https://github.com/librosa/librosa)
      * [Releases on GitHub](https://github.com/librosa/librosa/releases)

## General information

### Dependencies

  * Python dependencies:
      * [SoundFile](https://pypi.org/project/SoundFile/)
      * [audioread](https://pypi.org/project/audioread/)
      * [resampy](https://pypi.org/project/resampy/)
      * [numba](https://pypi.org/project/numba/) and its dependencies.
  * librosa depends on [libsndfile](http://www.mega-nerd.com/libsndfile/) which by 
    itself depends on several sound libraries.
  * librosa depends on FFmpeg via audioread (or GStreamer which we do not have installed)

Note that librosa is very picky on its dependencies. It tends to be lagging a bit. 
E.g., in June 2020, Python 3.8 was not yet supported and the then current version (0.7.2)
also did not work with the then current numba (0.49.1).

## EasyConfig

We started from scratch.

### 2019b toolchain

  * We did not try to bundle libsndfile with the Python packages and instead created 
    a separate module for it.
  * We decided to make a separate module for numba also as this package has a much 
    wider applicability. Moreover, we integrated LLVM into that package.

### 2020a toolchain - partly postponed

  * We moved libsndfile and the libraries on which it depends into the baselibs package.
  * We also stuck to a separate numba package.
  * Awaiting a new version that supports Python 3.8 and numba 0.49.1 as we do not want to
    compromise on the software experience of other users or support multiple versions in a
    toolchain.
