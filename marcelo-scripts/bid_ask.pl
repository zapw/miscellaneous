#!/usr/bin/perl 
#===============================================================================
#
#         FILE:  bid_ask.pl
#
#        USAGE:  ./bid_ask.pl  
#
#  DESCRIPTION:  
#
#      OPTIONS:  ---
# REQUIREMENTS:  ---
#         BUGS:  ---
#        NOTES:  ---
#       AUTHOR:  Dr. Fritz Mehner (mn), mehner@fh-swf.de
#      COMPANY:  FH Südwestfalen, Iserlohn
#      VERSION:  1.0
#      CREATED:  03/03/2020 11:33:06 AM
#     REVISION:  ---
#===============================================================================

use strict;
use warnings;

my @bid;
my $bid;
my $ask;
my @ask;
my $volume;
my $i = 0;
my $tmp;

while (<>){
	$tmp = ($_ =~  tr/SIO/510/r);
	if ($tmp =~ m/^(\d+)\s(?:x|X)\s(\d+)$/){
		$bid[$i] = $1;
		$ask[$i] = $2;

		$i++;
		next;
	}elsif ($tmp =~ m/^$/){
		next;
	}else { die "Unable to parse line '$_'" };

}
$bid += $_ for @bid;
$ask += $_ for @ask;
$volume = $bid + $ask;

print "$bid[0] x $ask[0] ---- " . ($bid-$bid[0]-$bid[-1]) . " x " . ($ask-$ask[0]-$ask[-1]) . " ---- $bid[-1] x $ask[-1]\n";
