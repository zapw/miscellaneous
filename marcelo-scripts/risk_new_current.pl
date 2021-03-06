#!/usr/bin/perl 
#===============================================================================
#
#         FILE:  risk.pl
#
#        USAGE:  ./risk.pl  
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
#      CREATED:  09/17/2018 11:16:49 AM
#     REVISION:  ---
#===============================================================================

use strict;
use warnings;


use Term::ReadLine;
use feature 'say';
use Scalar::Util 'looks_like_number';
use bignum;

my ($pos_portfolio,$sect_price,$stop_price,$buy_or_sell,$percnt_cur,$tget_price,$raw_risk_percnt,$cash,$raw_profit_percnt,$risk_ratio,$real_profit_percnt,$risk_cash,$pos_orderentry,$raw); 

my $term = Term::ReadLine->new('Foobar');

while (1){
	{
  	no warnings "uninitialized";
  	($pos_portfolio,$sect_price,$stop_price,$tget_price,$buy_or_sell,$raw) = undef;
  	$cash = $term->readline('Enter cash amount: ') until looks_like_number($cash) and $cash > 0;
  	$percnt_cur = $term->readline('Enter current working risk percent: ') until looks_like_number($percnt_cur) and $percnt_cur > 0;
	until (looks_like_number($sect_price) and $sect_price > 0){
  		$sect_price = $term->readline('Enter security price: ');
		$raw = 1 if $sect_price =~ s/r$//;
	}
  	$stop_price = $term->readline('Enter stop loss price: ') until looks_like_number($stop_price) and $stop_price > 0;
  	$tget_price = $term->readline('Enter profit target: ') until looks_like_number($tget_price) and $tget_price > 0;
  	$buy_or_sell = $term->readline('Enter buy or sell: ') until $buy_or_sell eq 'buy' or $buy_or_sell eq 'sell';
 	}

 	if ($buy_or_sell  eq 'sell'){
	 	$raw_risk_percnt = (abs($stop_price/$sect_price) - 1) * 100;
	 	$raw_profit_percnt = (1 - abs($tget_price/$sect_price)) * 100;
 	}elsif($buy_or_sell  eq 'buy'){
	 	$raw_risk_percnt = (1 - abs($stop_price/$sect_price)) * 100;
	 	$raw_profit_percnt = (abs($tget_price/$sect_price) - 1) * 100;

		if ($raw_profit_percnt/$raw_risk_percnt < 5){
			my $truncate = '';
			$truncate = 1 if (length (substr $sect_price, index($sect_price, '.') + 1) == 2);
	 		$sect_price = ($tget_price + 5 * $stop_price)/6;
			$sect_price = substr $sect_price, 0, index($sect_price, '.') + 3 if $truncate;
			my $bad_ratio = $raw_profit_percnt/$raw_risk_percnt;
	 		$raw_risk_percnt = (1 - abs($stop_price/$sect_price)) * 100;
	 		$raw_profit_percnt = (abs($tget_price/$sect_price) - 1) * 100;
			$sect_price -= 0.01 if $raw_profit_percnt/$raw_risk_percnt < 5;
			$raw_risk_percnt = (1 - abs($stop_price/$sect_price)) * 100;
	 		$raw_profit_percnt = (abs($tget_price/$sect_price) - 1) * 100;
 			if ($sect_price > $stop_price){
				say "WARNING: risk/profit ratio is 1 to ", $bad_ratio, "\nLowering entry price to '$sect_price'";
			}else{
				say "WARNING: risk/profit ratio is 1 to ", $raw_profit_percnt/$raw_risk_percnt, "\nTried lowering entry price to '$sect_price' but entry price is less than stop loss";
				next;
			}
		}elsif($raw_profit_percnt/$raw_risk_percnt >= 5.7 && !$raw){
			my $truncate = '';
			$truncate = 1 if (length (substr $sect_price, index($sect_price, '.') + 1) == 2);
	 		$sect_price = ($tget_price + 5.7 * $stop_price)/6.7;
			$sect_price = substr $sect_price, 0, index($sect_price, '.') + 3 if $truncate;
			my $bad_ratio = $raw_profit_percnt/$raw_risk_percnt;
			$raw_risk_percnt = (1 - abs($stop_price/$sect_price)) * 100;
	 		$raw_profit_percnt = (abs($tget_price/$sect_price) - 1) * 100;
			$sect_price += 0.01 if $raw_profit_percnt/$raw_risk_percnt >= 5.7;
			$raw_risk_percnt = (1 - abs($stop_price/$sect_price)) * 100;
	 		$raw_profit_percnt = (abs($tget_price/$sect_price) - 1) * 100;
			say "WARNING: risk/profit ratio is 1 to ", $bad_ratio, "\nIncreasing entry price to '$sect_price'";

		}
 	}




	if ($raw_risk_percnt <= $percnt_cur ){
		$risk_ratio = 1;
	}else{
 		$risk_ratio = $raw_risk_percnt / $percnt_cur;
	}
	$real_profit_percnt = $raw_profit_percnt / $risk_ratio;

 	$risk_cash = $cash / $risk_ratio;
 	$pos_orderentry = int($risk_cash/$sect_price);

 	say "Going ", do {"long " if ($buy_or_sell eq 'buy')}, do {"short " if ($buy_or_sell eq 'sell')}, ":\n","Raw risk percent is ", $raw_risk_percnt, "\n","Raw profit percent is ", $raw_profit_percnt, "\n",
 	"Real profit percent is ", $real_profit_percnt, "\n", "Position size is ", $pos_orderentry, "\n", "Risking $risk_cash in cash", "\n\n", "A 1 to '",$raw_profit_percnt/$raw_risk_percnt, "' risk to win ratio\n","Potential Loss in cash ", $raw_risk_percnt/100 * $risk_cash,"\n", "Potential win in cash ", $raw_profit_percnt/100 * $risk_cash;

}
