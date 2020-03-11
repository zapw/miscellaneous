#!/usr/bin/perl 
#===============================================================================
#
#         FILE:  trades.pl
#
#        USAGE:  ./trades.pl  
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
my $tmp;
my $trades;
my @trades;
my $i = 0;

while (<>){
        $tmp = ($_ =~  tr/SIO/510/r);
	if ($tmp =~ m/^(\d+)T$/){
		$trades[$i] = $1;
		$i++;
		next;
	}elsif ($tmp =~ m/^$/){
		next;
	}else { die "Unable to parse line '$_'" };

}
$trades += $_ for @trades;

print "$trades[0] ---- " . ($trades-$trades[0]-$trades[-1]) . " ---- $trades[-1]\n";
