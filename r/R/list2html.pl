#! /usr/bin/env perl
$, = ' ';		# set output field separator
$\ = "\n";		# set output record separator

print '<ul>';

while (<>) {
	chomp;
    ($Fld1,$Fld2) = split('\t', $_, -1);
    if (/^CRAN/) {
	    print "    <li/><a href=\"https://cran.r-project.org/web/packages/" .
              $Fld2 . "/index.html\">" . $Fld2 . ' (CRAN)</a>';
        next;
    }
    if (/^BIOCDA/) {
	    print "    <li/><a href=\"https://www.bioconductor.org/packages/release/data/annotation/html/"
              . $Fld2 . ".html\">" . $Fld2 . ' (BIOC DA)</a>';
        next;
    }
    if (/^BIOCEX/) {
	    print "    <li/><a href=\"http://bioconductor.org/packages/release/data/experiment/html/"
              . $Fld2 . ".html\">" . $Fld2 . ' (BIOC EX)</a>';
        next;
    }
    if (/^BIOC/) {
	    print "    <li/><a href=\"https://www.bioconductor.org/packages/release/bioc/html/"
              . $Fld2 . ".html\">" . $Fld2 . ' (BIOC)</a>';
        next;
    }
}

print '</ul>';