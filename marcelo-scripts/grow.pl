#!/usr/bin/perl

my $start =  147;


my $period = 10*12;
my $savings = 5;


for (my $i = 1; $i<=$period; $i++){
	if ($i % 36  == 0){
		#50 percent loss play every 3 years
		#$start  = ($start*2/3) + ($start/3 * 0.5) + 5;
		$start  = ($start * 0.5) + $savings;

	}elsif ($i % 6 == 0){
		#2 percent loss every 6 trades
		#start  = ($start*2/3) + ($start/3 * 0.98) + 5;
		$start  = ($start * 0.98) + $savings;
	}else{
		#$start  = ($start*2/3) + ($start/3 * 1.07) + 5;
		$start  = ($start * 1.07) + $savings;
	}
	print "month $i ", $start, "\n";
}
