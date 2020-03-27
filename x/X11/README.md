# X11 bundle

## EasyConfigs

Our X11 bundle is derived from the standard EasyBuild one, but with some local
additions to avoid installing those package separately.

### 2019b build set (GCCcore 8.3.0)

* Switched to GCCcore as the default EasyBuild recipes use GCCcore also. These
  libraries are likely not performance-critical for scientific applications on 
  a cluster, and it avoids having to develop patches for software that doesn't
  properly recognize the intel compilers or even breaks with them.
* Added two packages:
     * libdrm
     * DBus

### 2020a build set (GCCcore 9.3.0)

* We were running ahead of the default EasyBuild recipes with our installation
  for 2020a. As a result, we were the first to run into problems with 
  libxkbcommon which switched to the Meson build system in version 0.9.0.
  See the EasyConfig for the parameters that we used to get it to work with
  Meson.
* Note that our Meson setup is different from the standard EasyBuild one. 
  We don't have standard Meson and Ninja modules, but include both tools
  in our buildtools bundle and set appropriate EB values so that the
  MesonNinja EasyBlock recognizes them and thinks they are properly installed.
