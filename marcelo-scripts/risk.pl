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
my $margin_multi = 4;

my $term = Term::ReadLine->new('Foobar');

while (1){
 {
  no warnings "uninitialized";
  ($percnt_cur,$percnt_mod,$pos_orderentry,$pos_portfolio,$buy_or_sell) = undef;
  $percnt_cur = $term->readline('Enter current working risk percent: ') until looks_like_number($percnt_cur) and $percnt_cur > 0;
  $percnt_mod = $term->readline('Enter new percent appearing in chart: ') until looks_like_number($percnt_mod) and $percnt_mod > 0;

  $pos_orderentry = $term->readline('Enter position appearing in order entry: ') until looks_like_number($pos_orderentry) and $pos_orderentry > 0;
  $pos_portfolio = $term->readline('Enter current holding position: ') until looks_like_number($pos_portfolio);
  $buy_or_sell = $term->readline('Enter buy or sell: ') until $buy_or_sell eq 'buy' or $buy_or_sell eq 'sell';
 }

 $formula_pos = formula($percnt_mod,$percnt_cur);
 say "New percent is too high, new shares' number is '$formula_pos'" and next if $formula_pos <= 0;

 if ($pos_portfolio < 0 and $buy_or_sell eq 'buy'){
	say "Position for buy is ", abs($pos_portfolio) + $formula_pos,"
		Stop loss position is $formula_pos";
		check($formula_pos);
 }elsif($pos_portfolio > 0 and $buy_or_sell eq 'buy'){
	say "Position for buy is ", $formula_pos,"
		Stop loss position is ", $pos_portfolio + $formula_pos;
		check($pos_portfolio + $formula_pos);
 }elsif($pos_portfolio == 0 and $buy_or_sell eq 'buy'){
	say "Position for buy is ", $formula_pos,"
		Stop loss position is the same";
		check($formula_pos);
 }elsif($pos_portfolio < 0 and $buy_or_sell eq 'sell'){
	say "Position for sell is ", $formula_pos,"
		Stop loss position is ", abs($pos_portfolio) + $formula_pos;
		check(abs($pos_portfolio) + $formula_pos);
 }elsif($pos_portfolio > 0 and $buy_or_sell eq 'sell'){
	say "Position for sell is ", abs($pos_portfolio) + $formula_pos,"
		Stop loss position is $formula_pos";
		check($formula_pos);
 }elsif($pos_portfolio == 0 and $buy_or_sell eq 'sell'){
	say "Position for sell is ", $formula_pos,"
		Stop loss position is the same";
		check($formula_pos);
 }

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
