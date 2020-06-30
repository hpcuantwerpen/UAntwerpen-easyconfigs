#! /usr/bin/env perl
$, = ' ';		# set output field separator
$\ = "\n";		# set output record separator

print "# Run with: R --no-save <R-4.0.2-modules.R\n" .
      "CRANsite <- \"http://cran.r-project.org\"\n\n" .
      "install.packages(\"BiocManager\",         repos=CRANsite, type=\"source\")\n" .
      "BiocManager::install(version = \"3.11\", update = FALSE)\n\n";

while (<>) {
	chomp;
    ($Fld1,$Fld2,$Fld3,$Fld4) = split('\t', $_, -1);
    if (/^#/) {
        print $_;
        next;	
    }
    if (/^CRAN/ || /^BIOC/) {
    	if ( length $Fld4 ) {
    		print "# NEEDS ATTENTION!";
    	}
    	if ( length $Fld3 ) {
    		print "Sys.setenv( " . $Fld3 . ")";
    	}
    	if ( /^CRAN/) {
    		print "install.packages(\"" . $Fld2 . "\",repos=CRANsite, type=\"source\")";
    	} else {
    		print "BiocManager::install(c('" . $Fld2 . "'),update=FALSE)";
    	}
    	
    	if ( length $Fld3 ) {
    		($variable,$value) = split('=', $Fld3, -1);
    		print "Sys.unsetenv( '" . $variable . "')";
    	}
        next;
    }
}
