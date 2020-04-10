version='0.9.0'
patchfile="RAxML-NG-${version}_CMakeLists.patch"
patchfile2="RAxML-NG-${version}_terraphast_bugfix.patch"
patchdir_mac='../UAntwerpen-easyconfigs/r/RAxML-NG/'
patchdir_cluster="$VSC_DATA/EasyBuildDev/UAntwerpen-easyconfigs/r/RAxML-NG"

echo "Patches various CMakeLists.txt files to use the EasyBuild-suggested compile options and compilers."  > $patchfile
echo "Also corrects the FindGMP.cmake block included with terraphast."                                    >> $patchfile
echo "Author: Kurt Lust, UAntwerpen"                                                                      >> $patchfile
echo "diff -ru raxml-ng/CMakeLists.txt.orig                                  raxml-ng/CMakeLists.txt"                                  >> $patchfile
echo "diff -ru raxml-ng/src/CMakeLists.txt.orig                              raxml-ng/src/CMakeLists.txt"                              >> $patchfile
echo "diff -ru raxml-ng/test/src/CMakeLists.txt.orig                         raxml-ng/test/src/CMakeLists.txt"                         >> $patchfile
echo "diff -ru raxml-ng/libs/CMakeLists.txt.orig                             raxml-ng/libs/CMakeLists.txt"                             >> $patchfile
echo "diff -ru raxml-ng/libs/pll-modules/CMakeLists.txt.orig                 raxml-ng/libs/pll-modules/CMakeLists.txt"                 >> $patchfile
echo "diff -ru raxml-ng/libs/pll-modules/src/CMakeLists.txt.orig             raxml-ng/libs/pll-modules/src/CMakeLists.txt"             >> $patchfile
echo "diff -ru raxml-ng/libs/pll-modules/libs/libpll/src/CMakeLists.txt.orig raxml-ng/libs/pll-modules/libs/libpll/src/CMakeLists.txt" >> $patchfile
echo "diff -ru raxml-ng/libs/terraphast/CMakeLists.txt.orig                  raxml-ng/libs/terraphast/CMakeLists.txt"                  >> $patchfile
echo "diff -ru raxml-ng/libs/terraphast/cmake/FindGMP.cmake.orig             raxml-ng/libs/terraphast/cmake/FindGMP.cmake"             >> $patchfile

diff -ru raxml-ng/CMakeLists.txt.orig                                  raxml-ng/CMakeLists.txt                                         >> $patchfile
diff -ru raxml-ng/src/CMakeLists.txt.orig                              raxml-ng/src/CMakeLists.txt                                     >> $patchfile
diff -ru raxml-ng/test/src/CMakeLists.txt.orig                         raxml-ng/test/src/CMakeLists.txt                                >> $patchfile
diff -ru raxml-ng/libs/CMakeLists.txt.orig                             raxml-ng/libs/CMakeLists.txt                                    >> $patchfile
diff -ru raxml-ng/libs/pll-modules/CMakeLists.txt.orig                 raxml-ng/libs/pll-modules/CMakeLists.txt                        >> $patchfile
diff -ru raxml-ng/libs/pll-modules/src/CMakeLists.txt.orig             raxml-ng/libs/pll-modules/src/CMakeLists.txt                    >> $patchfile
diff -ru raxml-ng/libs/pll-modules/libs/libpll/src/CMakeLists.txt.orig raxml-ng/libs/pll-modules/libs/libpll/src/CMakeLists.txt        >> $patchfile
diff -ru raxml-ng/libs/terraphast/CMakeLists.txt.orig                  raxml-ng/libs/terraphast/CMakeLists.txt                         >> $patchfile

diff -ru raxml-ng/libs/terraphast/cmake/FindGMP.cmake.orig             raxml-ng/libs/terraphast/cmake/FindGMP.cmake                    >> $patchfile



echo "Patches for the terraphast component of RAxML-NG."                                          > $patchfile2
echo "* Fixes a problem with an implicit type conversion to a lesser type in a header file"      >> $patchfile2
echo "Author: Kurt Lust, UAntwerpen"                                                             >> $patchfile2
echo "diff -ru raxml-ng/libs/terraphast/lib/bits.hpp.orig raxml-ng/libs/terraphast/lib/bits.hpp" >> $patchfile2

diff -ru raxml-ng/libs/terraphast/lib/bits.hpp.orig raxml-ng/libs/terraphast/lib/bits.hpp        >> $patchfile2


if [[ $(hostname -s)  =~ "MBP-van-Kurt" ]]
then
  cp $patchfile  $patchdir_mac
  cp $patchfile2 $patchdir_mac
else
  cp $patchfile  $patchdir_cluster
  cp $patchfile2 $patchdir_cluster
fi
