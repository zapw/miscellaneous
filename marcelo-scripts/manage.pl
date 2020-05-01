#!/usr/bin/perl


use strict;
use warnings;
use feature 'say';
use JSON::PP;
use Getopt::Long;
use File::Copy;


my $ticker_file = "./ticker";
my $ticker_file_bak = "./ticker.bak_" . time;
my ($ticker,$new_size,$new_entry,$new_stoploss,$new_target,$new_cash,$update,@remove_ticker,$help);
my $divider = 7;
my $risk = 5;
my $multiplier = 1000;
$update = 0;
$help = 0;




GetOptions('risk=i{1,1}' => \$risk, 'divider=i{1,1}' => \$divider, 'ticker=s{1,1}' => \$ticker, 'size=i{1,1}' => \$new_size, 'entry=f{1,1}' => \$new_entry, 'stop=f{1,1}' => \$new_stoploss, 'target=f{1,1}' => \$new_target, 'cash=f{1,1}' => \$new_cash, 'update' => \$update, 'remove=s{1,}' => \@remove_ticker, 'h' => \$help) or die("Error in command line arguments\n");


sub exit_fun {
        say "USAGE:  $0 [--risk <risk>] [--divider <divider>] --ticker <ticker> --entry <num> --stoploss <stoploss> --target <target> --size <num> [--update] --remove <ticker> --cash <cash> [-h]";
        exit 1;
}
exit_fun() if $help;

open (my $ticker_fh, '<', $ticker_file) or die "Unable to open ticker file $!";

$/ = undef;
my $ticker_json = <$ticker_fh>;
close $ticker_fh;

my %ticker;
my $json = JSON::PP->new->ascii->pretty->allow_nonref;


my $ticker_scalar = $json->decode( $ticker_json );
my $capital = $ticker_scalar->{__CASH__}->[1];
if (defined $new_cash){
 $ticker_scalar->{__CASH__}->[0] = $capital;
 $ticker_scalar->{__CASH__}->[1] = $new_cash;
 $capital = $new_cash;
}

$capital *= $multiplier; 
#say "Total available capital after multiplier is ($capital), capital per trade is ($capital_divided), divider for total capital is ($divider), capital multiplier is $multiplier";

for my $remove_ticker (@remove_ticker){
	if (exists $ticker_scalar->{$remove_ticker}){
		say "Deleting ticker ($remove_ticker)";
		delete $ticker_scalar->{$remove_ticker};
	}else{
		die "Unable to find ticker ($remove_ticker)";
	}
}

if (defined $ticker){
	if (exists $ticker_scalar->{$ticker}){
		if (defined $new_entry){
			die "remove ($ticker) before replacing it with a new price entry";
		}
		$ticker_scalar->{$ticker}->[0] = $ticker_scalar->{$ticker}->[1];
		$ticker_scalar->{$ticker}->[1] = $new_size;
	}else{
		if (! defined $new_entry){
			die "entry price required for new ticker ($ticker)";
		}
		$ticker_scalar->{$ticker} = ['0', $new_size, $new_entry, $new_stoploss, $new_target, $risk, $divider];
	}
}

my ($oldsize, $size,$price,$stoploss,$target,$ticker_capital,$total_ticker_capital,$capital_divided,$risk_ratio,$percent_calculated);
for my $ticker (keys %$ticker_scalar){
	next if $ticker eq '__CASH__';
	$risk_ratio = 1;
	($oldsize, $size, $price,$stoploss,$target,$risk,$divider) = @{$ticker_scalar->{$ticker}};

	if ($price < $stoploss){
		$percent_calculated = (abs($stoploss/$price) - 1) * 100;
	}elsif($price > $stoploss){
		$percent_calculated = (1 - abs($stoploss/$price)) * 100;
	}

	if ($percent_calculated > $risk){
		$risk_ratio = $percent_calculated / $risk;
	}

	$capital_divided = $capital / $divider / $risk_ratio;

	$ticker_capital = $size*$price;
	say "Ticker ($ticker) size is ($size) price is ($price) used capital (" . $ticker_capital. "), percent to stoploss ($percent_calculated%), maximum trade risk ($risk%), position risk from capital (" . $ticker_capital/$capital*100 . "%), controlled risk (" . ($ticker_capital*$percent_calculated/100/$capital*100) . "%)";
	if ($ticker_capital > $capital_divided){
		$ticker_scalar->{$ticker}->[0] = $size;
		$ticker_scalar->{$ticker}->[1] = int($capital_divided / $price);
		say "\t Warning capital ($ticker_capital) is larger than maximum ($capital_divided) limit. Adjust size to ($ticker_scalar->{$ticker}->[1]), sell (" , $ticker_scalar->{$ticker}->[0] - $ticker_scalar->{$ticker}->[1] , ")";
	}
	$total_ticker_capital += $ticker_scalar->{$ticker}->[1]*$ticker_scalar->{$ticker}->[2]; 
}

if ($total_ticker_capital){
	if ($total_ticker_capital > $capital){
		say "WARNING: over exposed sum of tickers' capital ($total_ticker_capital) is larger than our total capital ($capital)";
	}else{
		say "total tickers' capital is $total_ticker_capital, remaining is ", $capital - $total_ticker_capital, " from $capital";
	}
}

if ($update){
	say "Backing up file to $ticker_file_bak";
	copy($ticker_file,$ticker_file_bak) or die "Copy failed: $!";
	say "Updating $ticker_file";
	open (my $ticker_fh, '>', $ticker_file) or die "Unable to open ticker file $!";
	print $ticker_fh $json->encode($ticker_scalar);
}
