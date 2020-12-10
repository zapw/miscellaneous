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


my $risk_ratio = 1;
my $original_risk_ratio = $risk_ratio;
my $risk_percent = 2;
my $risk_percent_weak = $risk_percent/2; 
my $cash_multiplier = 1000;
my $cash_divider = 7; # 1/7 of total cash per position
my $half = 0;
my $large = 0;
my (@cash,$entry,$stop);

sub exit_fun {
	say "USAGE:  $0  --cash <num> ... --entry <num> ... --stop <num> [--half]";
	exit 1;
}

exit_fun if @ARGV <= 1;


GetOptions('cash=f{1,}' => \@cash, 'entry=f{1,1}' => \$entry, 'stop:f{1,1}' => \$stop, 'half' => \$half, 'large' => \$large);

$risk_percent = $risk_percent_weak if $half == 1;
$cash_divider = 4 if $large == 1; # 1/4 of total cash per position
my $pos_orderentry;
my $original_pos_orderentry;
my $percent_calculated;
my $risk_cash;
my $original_risk_cash;
my $total = 0;
my $cash_per_trade;
$total += $_ for(@cash);
$total *= $cash_multiplier;

$cash_per_trade = $total / $cash_divider;

unless ($stop == 0){
	if ($entry < $stop){
		$percent_calculated = (abs($stop/$entry) - 1) * 100;
	}elsif($entry > $stop){
		$percent_calculated = (1 - abs($stop/$entry)) * 100;
	}


	#risk only 10 percent of $total money don't put more money because stop loss is less than $risk_percent
	#if ($percent_calculated < $risk_percent){ 
	#	$risk_ratio = 1 / $risk_percent / $percent_calculated;
	#}elsif ($percent_calculated > $risk_percent){
        $percent_calculated = $percent_calculated / 100 * $cash_per_trade / $total * 100;
	if ($percent_calculated > $risk_percent){
			$risk_ratio = $percent_calculated / $risk_percent;
			printf "%s%.2f%s%.2f%s%.2f%s\n", "Warning total cash risk with stoploss ", $percent_calculated, "% is larger than ", $risk_percent, "%. Risk divider set to (", $risk_ratio, ")";
	}elsif($percent_calculated < $risk_percent ){
		printf "%s%.2f%s\n", "Total cash risk with stoploss is ", $percent_calculated, "%";
	}

	#say " percent calculated is $percent_calculated";
	#say " risk percent is $risk_percent";
	#say " risk_ratio is $risk_ratio";
} else {
  $stop = abs($entry*(1-0.10));
  $stop =~ /(\d+)\./;
  my $digit = $1;
  if ($digit > 0){
	$stop =~ s/\.(\d\d)\d*/\.$1/;
  }else{
	$stop =~ s/\.(\d\d\d\d)\d*/\.$1/;
  }
  say "stop is $stop";
}
$risk_cash = $cash_per_trade / $risk_ratio;

if ($original_risk_ratio != $risk_ratio) {
	$original_risk_cash = $cash_per_trade / $original_risk_ratio;
	$original_pos_orderentry = int($original_risk_cash/$entry);
	say "Original Position is $original_pos_orderentry";
	say "Original USD ", $original_pos_orderentry * $entry;
}
say "Risk divider $cash_divider";

$pos_orderentry = int($risk_cash/$entry);

say "\n\nActual Position is ", $pos_orderentry;
say "Actual USD ", $pos_orderentry * $entry;
printf "%s%.2f%s%.3f\n", "Risking ", $pos_orderentry * $entry / $total * 100, "% of total USD cash ", $total / $cash_multiplier;
printf "%s%.3f\n", "Left USD cash ", ($total - $pos_orderentry * $entry) / $cash_multiplier;
say "Multiplier is $cash_multiplier";
