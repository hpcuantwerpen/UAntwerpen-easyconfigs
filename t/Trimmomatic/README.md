# Trimmomatic installation instructions

* [Trimmomatic webpage @ USADELLAB.org](http://www.usadellab.org/cms/?page=trimmomatic)

## General information

* Trimmomatic needs JAVA. 

## EasyConfig

There is support for Trimmomatic in EasyBuild.

We use the standard EasyBuild recipes with only cosmetic changes to bring them in
line with our documentation standards.

We also define the bash alias 'trimmomatic' to start Trimmomatic. It essentially
produce the ``java -jar``- command that would otherwise be needed to start
Trimmomatic.
