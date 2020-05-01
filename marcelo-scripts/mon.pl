#!/usr/bin/perl



my $cash = 40; 


my $times = 2*12;
my $years = 10;

for (my $x=1;$x<=$years;$x++){
 print "Year $x\n";
 my $year_win = 0;
 for (my $i=1;$i<=$times;$i++){
    my $trade = $cash/7;
    $trade = 60 if $trade > 60; 
    my $win = $trade*0.76;
    $cash += $win;
    $year_win += $win; 
    print "Win $win, total cash after win $cash, cash in position $trade\n";
 }
 $cash -= $year_win*0.25;
 $cash -= 51.42;
}
