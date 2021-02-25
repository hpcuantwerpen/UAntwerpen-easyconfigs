# kim-api installation instructions.

The KIM API is the API to use the [OpenKIM models database](https://openkim.org/)
from within applications.

  * [OpenKIM web site](https://openkim.org/)
      * [API download on that site](https://openkim.org/doc/usage/obtaining-models/#installing_api)
  * [kim-api on GitHub](https://github.com/openkim/kim-api)
      * [GitHub releases](https://github.com/openkim/kim-api/releases)

## General instructions

Installing the full OpenKIM collection requires two packages:
  * kim-api which provide the API
  * openkim-models: If you want to provide a system installation of the default
    models database.

The information in [the EasyBuild kim-api recipes](https://github.com/easybuilders/easybuild-easyconfigs/tree/master/easybuild/easyconfigs/k/kim-api)
suggest that CMake is needed for the model installation, hence likely used by
the ``kim-api-collections-management`` command.

## EasyBuild

There is [support for kom-api in the EasyBuilders repository](https://github.com/easybuilders/easybuild-easyconfigs/tree/master/easybuild/easyconfigs/k/kim-api).

We did modify the help text to make it relevant to the users at UAntwerpen.

### kim-api 2.2.1 in intel 2020a

  * We kept the download link used by the default EasyBuild recipes. It is also
    possible to download straight from GitHub.
  * Instead of CMake we add our buildtools module to the list of dependencies.
    CMake is needed to install models.

