#!/usr/bin/perl

use strict;
use warnings;


#=SUM(Sheet45!$J$8*Sheet45!$J$9,Sheet7!$J$8*Sheet7!$J$9,Sheet19!$J$8*Sheet19!$J$9,Sheet35!$J$8*Sheet35!$J$9,Sheet49!$J$8*Sheet49!$J$9)




my @sheets = qw(Sheet45 Sheet7 Sheet19 Sheet35 Sheet49);
my @string;
my $string;

for (@sheets){
  push @string ,  "'" . $_ . "'" . '!$J$8*' . "'" . $_ . "'" . '!$J$9';

}

$string = join ',' , @string;
$string = '=SUM(' . $string . ')';
print $string;
