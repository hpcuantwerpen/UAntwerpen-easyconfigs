# Build instructions for 2020a

  * Run 2020a-step01-system.yaml to install in the system modules directory

  * Run 2020a-step02-2020a.yaml to install in the 2020a modules directory

  * Complete manually the setup of the Intel toolchains

  * Not needed as the modules from Vaughan are used: Check how to do the Java install.

    Install the most recent EasyConfig and then rename the module or so?

  * Not needed as they can just be taken from Vaughan: In the background (as
    nothing really depends on it), run 2020a-step03[a|b]-x86_64.yaml,
    but we only need the modules and not re-install the software so it is not clear
    if one should do this from the easystack file.

  * TODO.
