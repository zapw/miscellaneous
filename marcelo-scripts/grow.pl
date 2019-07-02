#!/usr/bin/perl

my $start =  147;


my $period = 3*12;
my $savings = 5;


for (my $i = 1; $i<=$period; $i++){
	if ($i % 36  == 0){
		#50 percent loss play every 3 years
		#$start  = ($start*2/3) + ($start/3 * 0.5) + 5;
		$start  = ($start * 0.5) + $savings;

	}elsif ($i % 5 == 0){
		#10 percent loss every 5 trades
		#start  = ($start*2/3) + ($start/3 * 0.90) + 5;
		$start  = ($start * 0.90) + $savings;
	}else{
		#$start  = ($start*2/3) + ($start/3 * 1.3499996) + 5;
		$start  = ($start * 1.3499996) + $savings;
	}
	print "month $i ", $start, "\n";
}
