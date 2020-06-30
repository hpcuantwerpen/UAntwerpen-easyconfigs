#! /usr/bin/env perl
$, = ' ';		# set output field separator
$\ = "\n";		# set output record separator

print 'exts_list = [';

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
    		$option = "\n        'preinstallopts': '" . $Fld3 . "',\n    ";
    	} else {
    		$option = "";
    	}
    }
    if (/^CRAN/) {
    	print "    ('" . $Fld2 . "', '', {" . $option . "}), # " . 
              "https://cran.r-project.org/web/packages/" . $Fld2 . "/index.html";
        next;
    }
    if (/^BIOCDA/) {
    	print "    ('" . $Fld2 . "', '', {" . $option . "}), # " . 
              "https://www.bioconductor.org/packages/release/data/annotation/html/" . $Fld2 . ".html";
        next;
    }
    if (/^BIOCEX/) {
    	print "    ('" . $Fld2 . "', '', {" . $option . "}), # " . 
              "http://bioconductor.org/packages/release/data/experiment/html/" . $Fld2 . ".html";
        next;
    }
    if (/^BIOC/) {
    	print "    ('" . $Fld2 . "', '', {" . $option . "}), # " . 
              "https://www.bioconductor.org/packages/release/bioc/html/" . $Fld2 . ".html";
        next;
    }
}

print ']';