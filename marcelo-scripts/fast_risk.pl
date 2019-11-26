#!/usr/bin/perl 
#===============================================================================
#
#         FILE:  process.pl
#
#        USAGE:  ./process.pl  <watchlist> <ignorelist> <uplist> <downlist> <downlist> ...
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
#      CREATED:  07/14/2019 02:39:00 PM
#     REVISION:  ---
#===============================================================================

use strict;
use warnings;
use feature 'say';
use Getopt::Long;
use bignum;


my $risk_ratio;
my $risk_percent = 7;
my $cash_multiplier = 1000;
my $cash_divider = 10;
my (@cash,$entry,$stop);

sub exit_fun {
	say "USAGE:  $0  --cash <num> ... --entry <num> ... --stop <num>";
	exit 1;
}
exit_fun if @ARGV <= 1;

GetOptions('cash=f{1,}' => \@cash, 'entry=f{1,1}' => \$entry, 'stop=f{1,1}' => \$stop);

my $pos_orderentry;
my $percent_calculated;
my $risk_cash;
my $total = 0;
my $cash_per_trade;
$total += $_ for(@cash);

$cash_per_trade = $total*$cash_multiplier / $cash_divider;


if ($entry < $stop){
	$percent_calculated = (abs($stop/$entry) - 1) * 100;
}elsif($entry > $stop){
	$percent_calculated = (1 - abs($stop/$entry)) * 100;
}



if ($percent_calculated <= $risk_percent){
	$risk_ratio = 1;
}else{
		$risk_ratio = $percent_calculated / $risk_percent;
}

$risk_cash = $cash_per_trade / $risk_ratio;
$pos_orderentry = int($risk_cash/$entry);

say "Position is $pos_orderentry";
