# Baselibs

## Remarks on individual packages

### wget

* wget can now use libidn2 instead of libidn and PCRE2 instead of PCRE.
* According to the [EasyBuilders recipes](https://github.com/easybuilders/easybuild-easyconfigs/tree/develop/easybuild/easyconfigs/w/wget)
  wget 1.20 needs OpenSSL 1.0.1s or newer or GnuTLS 1.2.11 or newer, with GnuTLS being 
  the default it looks for if no --with-ssl is specified.

## EasyConfigs

### 2020a bundle

* Added lzip to the bundle.
* Added libdeflate to the bundle. Note that libdeflate contains its own gzip program, 
  but when installing it renames the executables to deflate-gzip and deflate-gunzip 
  to avoid a name clash.
* Added libidn and the newer libidn2 to the bundle
* Added wget to the bundle. Not really a library, but it is a tool that gets used by
  some packages and that requires other components from baseutils, so this is a better
  place to put it than, e.g., our buildtools module.



