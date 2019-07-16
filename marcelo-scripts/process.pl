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


my (@watchlist, @watchlist_ignore);
my (%watchlist, %watchlist_ignore);
my %scanner_list_down;
my %scanner_list_up;
my @not_in_watchlist;

if (@ARGV >= 4){
	open (my $watchlist_handler, '<', $ARGV[0]) or die "Unable to open $ARGV[0] $!";
	@watchlist = <$watchlist_handler> =~ m/,?\w+:(\w+)/g;
	@watchlist{@watchlist} = 1;
	open (my $watchlist_ignore_handler, '<', $ARGV[1]) or die "Unable to open $ARGV[1] $!";
	@watchlist_ignore = <$watchlist_ignore_handler> =~ m/,?\w+:(\w+)/g;
	@watchlist_ignore{@watchlist_ignore} = 1;

	open (my $scanner_output_up_handler, '<', $ARGV[2]) or die "Unable to open $ARGV[2] $!";
	my @tmp_list_up = <$scanner_output_up_handler>;
	shift @tmp_list_up;

	$scanner_list_up{(split /(\s+|,)/)[0]} = 1 for @tmp_list_up;

	for (my $i=3; $i < @ARGV; $i++){
		open (my $scanner_output_handler, '<', $ARGV[$i]) or die "Unable to open $ARGV[$i] $!";
		my @tmp_list = <$scanner_output_handler>;
		shift @tmp_list;

		for (@tmp_list){
			$scanner_list_down{(split /(\s+|,)/)[0]} = 1;
		}
	}

	for (keys %scanner_list_down){
		next if exists $watchlist{$_} || exists $watchlist_ignore{$_};
		push @not_in_watchlist, $_;
	}
	print "The following stocks are not in the watchlist:\n---\n", join "\n",  @not_in_watchlist, "---\n" if @not_in_watchlist;

	for (keys %scanner_list_up){
		if (exists $watchlist_ignore{$_}){
			say "Warning *** current ignore list '$ARGV[1]' has ticker '$_' which now moved to UP list in the scanner, remove ticker from ignore list";
		}
	}

}else { say "USAGE:  $0  <watchlist> <ignorelist> <uplist> <downlist> <downlist> ..." }
