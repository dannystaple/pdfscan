# Scan::Tiff Created By Danny Staple, 2006
# Use this module to manipulate the tiffs output from a scanner
# $Id: Tiff.pm 13 2006-07-05 21:52:01Z orionrobots $

=pod

=head1 Scan::Tiff Scanner tiff module

This module is a collection of functions that are handy to 
use with a scanned tiff image, or other images. 

You will need to have the "tiff" package installed, as it uses
command line tools from this to do its work.

It has been developed with Perl 5.8.7, but could be tested on
earlier versions.

=head2 stitch_tiffs(filelist, outputname)

This function will stich together the group of tiffs into a 
multipage tiff, which can later be used to make multipage PDFs.

filelist is a space separated list of the tiff files 
to stitch together. 

outputname is the file to output the stitched together tiffs 
to.

This returns the output, if any, of the tiffcp command.
=head2 tiff_to_pdf(inputname, outputname)

This will take a single, or multipage tiff, and convert it to 
a Jpeg encoded image in a PDF, with an a4 pagesize.

inputname - name and path of the file to convert
outputname - name and path to place the converted file

It will return the output, if any, of the tiff2pdf command.
=cut

use strict;
package Scanner;

BEGIN {
	use Exporter();
	@basic::ISA = qw(Exporter);
	@basic::EXPORT = qw(&stitch_tiffs, &tiff_to_pdf);
	`which tiff2pdf` or die("tiff2pdf not found - please install it");

}

sub stitch_tiffs($$) {
	my $cpargs = shift;
	my $outputname = shift;
	return `tiffcp $cpargs $outputname`;
}

sub tiff_to_pdf($$) {
	my $inputname = shift;
	my $outputname = shift;
	#convert to pdf with jpeg compression - pass in our image stream
	return `tiff2pdf $inputname -j -p A4 -o $outputname 2>&1`;
}

return 1;
END { }
