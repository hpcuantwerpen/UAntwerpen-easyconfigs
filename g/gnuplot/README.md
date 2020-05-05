# GNUplot installation instruction

* [GNUplot home page](http://gnuplot.sourceforge.net/)

## General remarks

* GNUplot 5.2.x is incompatible with libgd 2.3.x as it uses the libgd-config script
  which is dropped from the 2.3.x releases of libgd (after being deprecated for a while).
  The problem here is that 2.3.x does solve security problems present in the 2.2.5
  release so reverting to an older version of libgd isn't really a solution either...

## EasyConfigs

The structure of our EasyConfig files is a bit different from those of the EasyBuilders 
repositories as we have split up the dependencies to make it easier to enable or disable
certain options in GNUplot.

### 5.4.0 for 2020a

* We had to use preconfigopts to change the LIBS variable to avoid the error message 
  about libiconv_open.

 