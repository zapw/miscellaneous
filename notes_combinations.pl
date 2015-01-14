use warnings;
use strict;

# while sum_price  = price product + sum of bills in cashier bigger than:
#> 143 then start substracting 100s
#>= 100 then check if there is 100 dollar bill if so substract
#> 93 then then start substracting 50s
#> 23 then check if there is a 50 dollar bill if so substract if still larger than 23 start substracting 20s.
#> 13 then check if there is a 20 dollar bill if so substract if still larger than 13 start substracting 10s
#>= 10 look for a bill of 10s and substract it
#>= 5  look for bill of 5 and substract it
#> 1  look for bill of 2 and substract it
#> 0 look for bill of 1s and substract it

my %bill = ( 100=>{ max => 1 , value => 0}, 50=>{ max => 1 , value => 0},  20=>{ max => 4, value => 0}, 10=>{ max => 9, value => 0}, 5=>{ max => 19 , value => 0},
  2=>{ max => 49 , value => 0}, 1=>{ max => 99 , value => 0} );
#my %bill = ( 100=>1, 50=>1, 20=>4, 10=>9, 5=>19, 2=>49, 1=>99 );
  
my @amount;
COUNT: {
  for (sort { $b <=> $a } keys %bill) {
    if ( $bill{$_}->{value} < $bill{$_}->{max} ) {
      my $sum_bill;
      $bill{$_}->{value}++;
      for (keys %bill) {
        $sum_bill += $bill{$_}->{value} * $_; 
      }
      if ($sum_bill < 144) {
        my $hash = return_values(\%bill);
        #my $hash = return_values();
        unless ( exists $amount[$sum_bill] ) {
          #push @{$amount[$sum_bill]}, $hash;
          $amount[$sum_bill]->[0] = $hash;
        } 
        elsif ( $hash->{total_notes} < $amount[$sum_bill]->[0]->{total_notes} ) { 
          unshift @{$amount[$sum_bill]}, $hash;
          #@{$amount[$sum_bill]} = ($hash);
        }
        elsif ( $hash->{total_notes} >= $amount[$sum_bill]->[0]->{total_notes} ) {
        #elsif ( $hash->{total_notes} == $amount[$sum_bill]->[0]->{total_notes} ) {
          push @{$amount[$sum_bill]}, $hash;
        }
      } 
      else {
          $bill{$_}->{value} = 0;
          next;
      }
      redo COUNT;
    } 
    else {
        $bill{$_}->{value} = 0;
    }
  }
}

#while (my ($index, $elem) = each @amount) {
{
  my ($index, $elem) = (44, $amount[44]);
  print "Bills for $index: \n";
    for my $bills ( @{$elem}) {
      my $total_notes = $bills->{total_notes};
      delete $bills->{total_notes};
      print " [\n";
      for (sort { $b <=> $a } keys %{$bills}) {
        print "   bill $_ times $bills->{$_}\n";
      }
      print "   bill total $total_notes\n ]\n\n";
    }
}

END { print time  - $^T, "\n" }
=com
my $price = 1;
my $sum;
$sum += $bill{$_}->{max} * $_ for keys %bill;

my $kabala = $sum + $price;

while ( $kabala > 143 and $bill{100}->{max} > 0) {
  $bill{100}->{max}--;
  $kabala -= 100;
}
if ($kabala >=100 and $bill{100}->{max} > 0) {
  $bill{100}->{max}--;
  $kabala -= 100;
}
  
while ( $kabala > 93 and $bill{50}->{max} > 0) {
  $bill{50}->{max}--;
  $kabala -= 50;
}

while ( $kabala > 73 and $bill{20}->{max} > 0) {
  $bill{20}->{max}--;
  $kabala -= 20;
}
if ($kabala > 23 and $bill{50}->{max} > 0) {
  $bill{50}->{max}--;
  $kabala -= 50;
}

while ( $kabala > 13 and my $hash = pop @{$amount[10]} ) {
  $bill{$_}->{max} -= $hash->{$_} for keys %$hash;
  $kabala -= 10;
}
if ($kabala > 13 and $bill{20}->{max} > 0) {
  $bill{20}->{max}--;
  $kabala -= 20;
}

for my $note (10,5) {
  if ($kabala >= $note and $bill{$note}->{max} > 0) {
    $bill{$note}->{max}--;
    $kabala -= $note;
  }
}

for my $note (2,1) {
  if ($kabala > $note-1 and $bill{$note}->{max} > 0) {
    $bill{$note}->{max}--;
    $kabala -= $note;
  }
}

$sum = 0;
$sum += $bill{$_}->{max} * $_ for keys %bill;
print $kabala, "\n", $sum;

=cut
sub return_values {
  my $bill = shift;
  my ($total_notes, %hash);
  for (keys %$bill) {  
  #for (keys %bill) {  
    if ($bill->{$_}->{value} > 0) {
    #if ($bill{$_}->{value} > 0) {
      $total_notes += $bill->{$_}->{value};
      #$total_notes += $bill{$_}->{value};
      $hash{$_} = $bill->{$_}->{value};
      #$hash{$_} = $bill{$_}->{value};
    }
  }
  $hash{total_notes} = $total_notes;
  return \%hash;
}





