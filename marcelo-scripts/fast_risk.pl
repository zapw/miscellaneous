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
my $risk_percent = 10;
my $risk_percent_weak = $risk_percent/2; 
my $cash_multiplier = 1000;
my $cash_divider = 10; # 1/10 of total cash per position
my $half = 0;
my (@cash,$entry,$stop);

sub exit_fun {
	say "USAGE:  $0  --cash <num> ... --entry <num> ... --stop <num> [--half]";
	exit 1;
}

exit_fun if @ARGV <= 1;


GetOptions('cash=f{1,}' => \@cash, 'entry=f{1,1}' => \$entry, 'stop:f{1,1}' => \$stop, 'half' => \$half);

$risk_percent = $risk_percent_weak if $half == 1;
my $pos_orderentry;
my $percent_calculated;
my $risk_cash;
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
	if ($percent_calculated > $risk_percent){
			$risk_ratio = $percent_calculated / $risk_percent;
			say "Warning $percent_calculated"."% is larger than $risk_percent"."%, risk divider ($risk_ratio)";
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

#don't care about actual putting half of 1/10 of money, care more about putting half of the usual risk on a trade
#my $half_cash = $total / 2;
#$risk_cash = $half_cash if $risk_cash > $half_cash;

$pos_orderentry = int($risk_cash/$entry);

say "Position is $pos_orderentry";
