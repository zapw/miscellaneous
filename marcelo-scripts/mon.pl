#!/usr/bin/perl



my $cash = 40; 


my $times = 144;
my $years = 10;
my $year_win;
my $win;

for (my $x=1;$x<=$years;$x++){
 print "Year $x\n\n";
 $year_win = 0;
 for (my $i=1;$i<=$times;$i++){
    $win = 0;
    my $trade = $cash/7;
    $trade = 60 if $trade > 60; 
    if ($i % 5 == 0 ){
	$win = $trade*0.76;
	print 'Win ';
    }else{
	$win = $trade*-0.07;
	print 'Loss ';
    }
    $cash += $win;
    $year_win += $win; 
    print "$win, total cash after win $cash, cash in position $trade\n";
 }
 $cash -= $year_win*0.25;
 $cash -= 51.42;
}
