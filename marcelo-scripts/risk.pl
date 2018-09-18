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


#enter desired risk percent
#0 not allowed negative not allowed

#enter new percent


#enter current position

#if new percenet negative or 0 reprompt

#if new percent larger than old percent than use decrese formula 
#if new percent smaller than old percent than use increase formula

#long or short
#enter current holding position

#if position negative and long add (ereh muhlat) of negative position plus calculated position after formula - update stop loss equal to new calculated position after formula
#if position positive and long add (ereh muhlat) of position plus calculated position after foruma - update stop loss equal to ereh muhlat of position plus calculated position after formula


#if position zero and long add calculated position after formula - update stop loss equal to calcualted position after formula

#if position negative and short decrese of negative position by calculated position after formula - update stop loss equal to ( ereh muhlat of of position plus calculated position after formula ) 
#if position positive and short decrease by current positive position plus calculated position after formula - update stop loss to equal to new calculated position after formula 
#if position zero and short decrese position after formula - update stop loss equal to calculated position after formula


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

my $term = Term::ReadLine->new('Foobar');

while (1){
 {
  no warnings "uninitialized";
  $percnt_cur = $term->readline('Enter current working risk percent: ') until looks_like_number($percnt_cur) and $percnt_cur > 0;
  $percnt_mod = $term->readline('Enter new percent appearing in chart: ') until looks_like_number($percnt_mod) and $percnt_mod > 0;
  $pos_orderentry = $term->readline('Enter position appearing in order entry: ') until looks_like_number($pos_orderentry) and $pos_orderentry > 0;
  $pos_portfolio = $term->readline('Enter current holding position: ') until looks_like_number($pos_portfolio);
  $buy_or_sell = $term->readline('Enter buy or sell: ') until $buy_or_sell eq 'buy' or $buy_or_sell eq 'sell';
 }
 $formula_pos = formula($percnt_mod,$percnt_cur);
 say "new percent is too high, new shares' number is $formula_pos" and next if $formula_pos <= 0;

 if ($pos_portfolio < 0 and $buy_or_sell eq 'buy'){
	say "Position for buy is ", abs($pos_portfolio) + $formula_pos,"
		Stop loss position is $formula_pos";
 }elsif($pos_portfolio > 0 and $buy_or_sell eq 'buy'){
	say "Position for buy is ", $formula_pos,"
		Stop loss position is ", $pos_portfolio + $formula_pos;
 }elsif($pos_portfolio == 0 and $buy_or_sell eq 'buy'){
	say "Position for buy is ", $formula_pos,"
		Stop loss position is the same";
 }elsif($pos_portfolio < 0 and $buy_or_sell eq 'sell'){
	say "Position for sell is ", $formula_pos,"
		Stop loss position is ", abs($formula_pos) + $formula_pos;
 }elsif($pos_portfolio > 0 and $buy_or_sell eq 'sell'){
	say "Position for sell is ", abs($pos_portfolio) + $formula_pos,"
		Stop loss position is $formula_pos";
 }elsif($pos_portfolio == 0 and $buy_or_sell eq 'sell'){
	say "Position for sell is ", $formula_pos,"
		Stop loss position is the same";
 }

 ($percnt_cur,$percnt_mod,$pos_orderentry,$pos_portfolio,$buy_or_sell) = undef;
}

sub formula{
	my ($percnt_mod,$percnt_cur) = @_;
	if ($percnt_mod > $percnt_cur){
		return ($percnt_cur - $percnt_mod/$percnt_cur) * $pos_orderentry
	}else{
		return $percnt_cur/$percnt_mod * $pos_orderentry
	}
}
