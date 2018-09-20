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

my $percnt_cur;
my $percnt_mod;
my $pos_orderentry;
my $pos_portfolio;
my $buy_or_sell;
my $formula_pos;
my $cash;
my $sect_price;
my $stop_price;
my $margin_multi = 4;
my $profit_target;
my $rsk_proft_ratio;
my $suggest_rsk_proft_ratio = 1.9;

my $term = Term::ReadLine->new('Foobar');

while (1){
 {
  no warnings "uninitialized";
  ($pos_portfolio,$sect_price,$stop_price,$buy_or_sell) = undef;
  $cash = $term->readline('Enter cash amount: ') until looks_like_number($cash) and $cash > 0;
  $percnt_cur = $term->readline('Enter current working risk percent: ') until looks_like_number($percnt_cur) and $percnt_cur > 0;
  $rsk_proft_ratio = $term->readline('Enter risk/profit ratio (suggested ' . $suggest_rsk_proft_ratio . ') :') until looks_like_number($rsk_proft_ratio) and $rsk_proft_ratio >0;
  $sect_price = $term->readline('Enter security price: ') until looks_like_number($sect_price) and $sect_price > 0;
  $stop_price = $term->readline('Enter stop loss price: ') until looks_like_number($stop_price) and $stop_price > 0;
  $pos_portfolio = $term->readline('Enter current holding position: ') until looks_like_number($pos_portfolio);
  $buy_or_sell = $term->readline('Enter buy or sell: ') until $buy_or_sell eq 'buy' or $buy_or_sell eq 'sell';
 }

 if ($buy_or_sell  eq 'sell'){
	$profit_target = $sect_price - (abs($sect_price - $stop_price) * $rsk_proft_ratio);
 }elsif($buy_or_sell  eq 'buy'){
	$profit_target = $sect_price + (abs($sect_price - $stop_price) * $rsk_proft_ratio);
 }

 $pos_orderentry = int($cash/$sect_price);
 $percnt_mod = (abs($sect_price - $stop_price) * $pos_orderentry) / $cash * 100;

 $formula_pos = formula($percnt_mod,$percnt_cur);
 say "Stop loss margin is too high, new shares' number is '$formula_pos'" and next if $formula_pos <= 0;

 if ($pos_portfolio < 0 and $buy_or_sell eq 'buy'){
	say_result('buy',abs($pos_portfolio) + $formula_pos,$formula_pos)
 }elsif($pos_portfolio > 0 and $buy_or_sell eq 'buy'){
	say_result('buy',$formula_pos,$pos_portfolio + $formula_pos)
 }elsif($pos_portfolio == 0 and $buy_or_sell eq 'buy'){
	say_result('buy',$formula_pos)
 }elsif($pos_portfolio < 0 and $buy_or_sell eq 'sell'){
	say_result('sell',$formula_pos,abs($pos_portfolio) + $formula_pos)
 }elsif($pos_portfolio > 0 and $buy_or_sell eq 'sell'){
	say_result('sell',abs($pos_portfolio) + $formula_pos,$formula_pos)
 }elsif($pos_portfolio == 0 and $buy_or_sell eq 'sell'){
	say_result('sell',$formula_pos)
 }
}

sub say_result{
	my ($stoploss,$stoploss_txt);
	my ($buy_or_sell,$position,$stop_loss) = @_;
	if (defined $stop_loss){
		$stoploss_txt = $stop_loss;
		$stoploss = $stop_loss;
	}else{
		$stoploss_txt = 'the same';
		$stoploss = $position;
	}

	say "Position for $buy_or_sell is ", $position,"
		Stop loss position is $stoploss_txt (your stop loss margin was $percnt_mod%, new position reflects $percnt_cur%)
		Profit target is $profit_target";
		check($stoploss);
}

sub formula{
	my ($percnt_mod,$percnt_cur) = @_;
	if ($percnt_mod > $percnt_cur){
		return ($percnt_cur - $percnt_mod/$percnt_cur) * $pos_orderentry
	}else{
		return $percnt_cur/$percnt_mod * $pos_orderentry
	}
}

sub check{
	my ($holding_shares) = @_;
	say "NOTE NEW HOLDINGS WILL BE LARGER THAN ALLOWED MARGIN OF $margin_multi" if $holding_shares/$pos_orderentry > 4;
}
