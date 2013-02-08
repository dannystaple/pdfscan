#!/usr/bin/perl
# PDFScanCore is the core functionality of the system.
# It does not however deal with user interface
# Adapted by Danny Staple, 2006
# $Id: PDFScanCore.pl 19 2008-02-02 13:41:32Z dannystaple $

use strict;
use FindBin;
use lib $FindBin::Bin;
use File::Copy;
use Scanner::Basic;
use Scanner::Tiff;

package PDFScanCore;

BEGIN {
}

sub new
{
	my $self = {};
	# Init the scanner
	$self->{scannerDevice} = Scanner::acquire_scanner();
	# Get the output filename
	$self->{outputName} = shift;
	$self->{cpArgs} = "";
	$self->{count} = 0;
	bless($self);	
	return $self;
}

sub scan_page
{
	my $object = shift;
	$object->{count} ++;
	my $filename = "temp-" . $object->{outputName} . "-" . $object->{count} . ".tiff";
	Scanner::scan_tiff($object->{scannerDevice},$filename);
	$object->{cpArgs} = $object->{cpArgs} . " $filename";
	#Return 1 to say we are okay at this point
	return 1;
}

sub needs_stitching 
{
	my $object = shift;
	return $object->{count} > 0;
}

sub stitch_pages
{
	my $object = shift;
	my $retval = undef;
	my $outnameAll = "temp-" . $object->{outputName} . "-all.tiff";
	if ($object->needs_stitching())
	{
		$retval = Scanner::stitch_tiffs($object->{cpArgs}, $outnameAll);
	}
	else 
	{
		move("temp-" . $object->{outputName} . "-1.tiff", $outnameAll) or $retval = $!;
	}
	return $retval;
}

sub convert_to_pdf
{
	my $object = shift;
	my $retval = undef;
	
	Scanner::tiff_to_pdf("temp-" . $object->{outputName} . "-all.tiff", $object->{outputName});
	
	return $retval;
}

sub clean_up
{
	my $object = shift;
	my $retval = undef;
	
	if ($object->{count} > 1) {
		for my $i (1..$object->{count}) {
		  my $filename = "temp-" . $object->{outputName} . "-$i.tiff";
		  unlink($filename) or $retval = "Unable to delete $filename $!\n";
		}
	}
	unlink("temp-" . $object->{outputName} . "-all.tiff") or $retval = "Failed to remove output file $!\n";

	return $retval;
}	

return 1;
END { }

