#! perl -w

=head1 NAME

check_services.pl - checks for the nagios services redundant to NSClient stuff.

=head1 VERSION

Version 1.0

=head1 SYNOPSIS

  check_services.pl Service1 Service2 Service3

=head1 AUTHOR

(c) 2003 Hannes Schulz <mail@hannes-schulz.de>

=cut


use Win32::Service;
use Data::Dumper;
use strict;
my @out = ();
my $state;
my $ret = 0;
my %s;

foreach(@ARGV){

	next unless($_ and /\w+/);

	Win32::Service::GetStatus("",$_,\%s);
	$state = $s{CurrentState};
	$state ||= "Unknown";
	if($state eq "4"){
		$state = "Started"
	}elsif($state eq "Unknown"){
		;
	}else{
		$state = "Stopped"
	}

	push @out,"$_: $state";
	$ret = 2 if($state eq "Stopped");
	$ret = 1 if($state eq "Unknown" and $ret<2);
}

print join(", ", @out);
exit $ret;
