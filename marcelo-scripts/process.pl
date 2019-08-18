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


my (%watchlist, %ignorelist);
my %scanner_list_down;
my %scanner_list_up;
my %negate_list;
my @not_in_watchlist;
my (@watchlist_files,@ignore_files,@up_files,@down_files,@negate_files);

say "USAGE:  $0  --watch <file> ... --ignore <file> ... --up <file> ... --down <file> ..."  if @ARGV <= 1;

GetOptions('watch=s{1,}' => \@watchlist_files, 'ignore=s{1,}' => \@ignore_files, 'up=s{1,}' => \@up_files, 'down=s{1,}' => \@down_files, 'negate=s{1,}' => \@negate_files);


sub watch_ignore {
	my (%list, @list);
	for (my $i=0; $i < @_; $i++){
		open (my $handler, '<', $_[$i]) or die "Unable to open $_[$i] $!";
		@list = <$handler> =~ m/:(\S+?)(?:,|$)/g;
		@list{@list} = 1;
	}
	return %list;
}

sub up_down {
	my %scanner_list;
	my $stockname;
	for (my $i=0; $i < (@_ - 1); $i++){
		open (my $handler, '<', $_[$i]) or die "Unable to open $_[$i] $!";
		my @tmp_list_up = <$handler>;
		shift @tmp_list_up;

		#$scanner_list{(split /(\s+|,)/)[0]} = 1 for @tmp_list_up;
		for (@tmp_list_up){
			$stockname = (split /$_[-1]/)[0];
			$stockname = join '.', split " ", $stockname;

			#$scanner_list{(split /(\s+|,)/)[0]} = 1 for @tmp_list_up;
			$scanner_list{$stockname} = 1;
		}
	}
	return %scanner_list;
}

%watchlist = watch_ignore(@watchlist_files);
%ignorelist = watch_ignore(@ignore_files);

%scanner_list_up = up_down(@up_files,'\S+,');
%scanner_list_down = up_down(@down_files,'\S+,');

%negate_list = up_down(@negate_files,',');


for (keys %scanner_list_down){
	next if exists $watchlist{$_} || exists $ignorelist{$_} || exists $negate_list{$_};
	push @not_in_watchlist, $_;
}
print "The following stocks are not in the watchlist:\n---\n", join "\n",  @not_in_watchlist, "---\n" if @not_in_watchlist;

for (keys %scanner_list_up){
	if (exists $ignorelist{$_}){
		say "Warning *** ticker '$_' moved to UP list in the scanner, remove ticker from ignore list";
	}
	if (exists $scanner_list_down{$_}){
		say "Warning *** ticker '$_' exists both in UP and DOWN list, list are not up to date";
	}
}

for (keys %watchlist){
	say "Warning *** ticker '$_' exists both in ignorelist and watchlist list" if exists $ignorelist{$_};
}
