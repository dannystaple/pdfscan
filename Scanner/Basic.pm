# Scan::Basic Created By Danny Staple, 2006
# Use this module to interface with a scanner device
# $Id: Basic.pm 13 2006-07-05 21:52:01Z orionrobots $

=pod

=head1 Scan::Basic Scanner device module

This interface is a simple way to communicate with a scan 
device from perl scripts on machines that support L<sane>.

It assumes that you have sane installed, and since it 
currently works in tiffs, you should probably have the  
"tiff" package installed too.

It has been developed with Perl 5.8.7, but could be tested on
earlier versions.

=head2 acquire_scanner( )

The acquire_scanner function will return the device identification 
for a currently configured and installed scanner. It is not 
particularly clever, and actually just snips it from the last line 
of scanimage --help.

Returns a string with the scanner reference which can be used in 
subsequent scanner functions

Example:

C<my $scanner = acquire_scanner()>

=head2 scan_tiff(scannerdevice, outputfilename)

This will scan a 300 DPI Color tiff from the specified scanner, 
outputting it to the specified filename.

=cut

use strict;

package Scanner;
use English;

BEGIN {
	use Exporter();
	@basic::ISA = qw(Exporter);
	@basic::EXPORT = qw(&acquire_scanner, &scan_tiff);
	`which scanimage` or die("This tool requires SANE to be installed");
}
 
sub acquire_scanner() {
	#Read output of help command to get scanner device name
	my $scannerdevice =`scanimage --help | tail --lines=1 `;
	chomp($scannerdevice);
	return $scannerdevice;
}

sub scan_tiff($$) {
	#Scan a single tiff image
	#Usage: scan_tiff($scannerdevice, $outputname)
	#Return The status
	my ($scannerdevice, $outputname) = @ARG;
	#scan the A4 file uncompressed at 300dpi 
	#--quick-format A4 - Note we are creating a temp file until we can find a way
	#to get tiff2pdf to take standard input
	my $errorlog = "/tmp/pdfscan_${outputname}_errorlog";
	`scanimage -d $scannerdevice --mode Color --resolution 300 --format tiff >$outputname 2>$errorlog`;
	return (join('\n', <$errorlog>));
}

return 1;
END { }
