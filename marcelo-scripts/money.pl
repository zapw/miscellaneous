use strict;
use warnings;
use feature 'say';
use List::Util;

binmode(STDOUT, ":unix:utf8");

BEGIN { 
	if ($^O eq 'MSWin32') {
		$SIG{INT} = "IGNORE";
		require Win32::API;
		Win32::API->import();
		our $SetConsoleOutputCP = Win32::API->new( 'kernel32.dll', 'SetConsoleOutputCP', 'N','N' );
		$SetConsoleOutputCP->Call(65001);
	}
}

my %bill = ( 50=>{ max => 1 , value => 0},  20=>{ max => 4, value => 0}, 10=>{ max => 9, value => 0}, 5=>{ max => 19 , value => 0},
  2=>{ max => 49 , value => 0}, 1=>{ max => 99 , value => 0} );
  
#print "Enter number of bills [", (join ', ', map { "$_=>" . $bill{$_}->{max} } sort { $b <=> $a } keys %bill), "]: ";
#my $var = <STDIN>;
#chomp $var

  
my ($euro2dollar, $dollar2euro) = 0;

printf "Loading...\r";
my @amount;
COUNT: {
  for (sort { $b <=> $a } keys %bill) {
    if ( $bill{$_}->{value} < $bill{$_}->{max} ) {
      my $sum_bill;
      $bill{$_}->{value}++;
      for (keys %bill) {
        $sum_bill += $bill{$_}->{value} * $_; 
      }
      if ($sum_bill < 100) {
        my $hash = return_values();
        unless ( exists $amount[$sum_bill] ) {
          #push @{$amount[$sum_bill]}, $hash;
          $amount[$sum_bill]->[0] = $hash;
        } 
        elsif ( $hash->{total_notes} < $amount[$sum_bill]->[0]->{total_notes} ) { 
          #unshift @{$amount[$sum_bill]}, $hash;
          @{$amount[$sum_bill]} = ($hash);
        }
        elsif ( $hash->{total_notes} == $amount[$sum_bill]->[0]->{total_notes} ) {
        #elsif ( $hash->{total_notes} >= $amount[$sum_bill]->[0]->{total_notes} ) {
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

COIN: {
  ($euro2dollar, $dollar2euro) = convert_coin("Euro to Dollar rate [@{[ grep { defined } $euro2dollar  ]}]: ");
  printf "Euro is %.2f dollars\nDollar is %.2f Euros\n", $euro2dollar, $dollar2euro;

  ITEMS: { 
    my $number_items = number_items("Enter number of items [or leave blank]: ");
    $number_items = 0 unless defined $number_items;
  
    my $total_discount;
    my $total_discount_saved;
    LOOP: while (1) {
	  if (defined $total_discount_saved){
			$total_discount = $total_discount_saved;
			undef $total_discount_saved;
	  }
      my ($sum_raw, $raw_items) = sum_items("item prices before discount" . (($number_items > 0) and " [$number_items items remaining]") . ": ",'ITEMS');
      printf "raw price $sum_raw\$ or %.2f\x{20AC}\n\n", $sum_raw * $dollar2euro;

      my ($sum_discount) = sum_items("item prices after discount: ",'LOOP');
      printf "price with discount $sum_discount\$ or %.2f\x{20AC}\n\n", $sum_discount * $dollar2euro;

      my $percent =  eval { ($sum_discount+0) / ($sum_raw+0) };
      redo unless defined $percent;
      printf $percent >= 1 ? ("%s\n", "no discount") : ("discount of %%%.1f\n",  (1 - $percent) * 100);

      my (@discount_items, @items, $remain);
      for (my $i = 0, ; $i < @$raw_items; $i++) {
        $discount_items[$i] = sprintf "%.0f", $raw_items->[$i] * $percent;
        $remain += $discount_items[$i];
        push @items, $raw_items->[$i], $discount_items[$i];
      }

      $items[-1] = $sum_discount - ($remain - $discount_items[-1]);
      say join "\n", List::Util::pairmap { "$a => $b" } @items;
  
      $total_discount += $sum_discount;
      if ($number_items > 0) {
        $number_items -= @{$raw_items};
        redo LOOP if $number_items > 0;
      }
      printf "Total amount after discount is $total_discount\$ or %.2f\x{20AC}\n", $total_discount * $dollar2euro;
      { 
		$total_discount_saved //= $total_discount;
        my ($sum_received, $raw_payments) = sum_items("Enter received amounts ['done' to finish]: ",'LOOP',"%.2f");
        if ( ( my $change = $total_discount - $sum_received) > 0) {
          printf "Missing %.2f\$ or %.2f\x{20AC}\n", $change,  $change * $dollar2euro;
		  $total_discount = $change;
        } 
        else {
          if ($change < 0) {
            printf "Change is %.2f\$ or %.2f\x{20AC}\n", $change,  $change * $dollar2euro;
            my $index = abs($change);
            if (exists $amount[$index]) {
              my $elem = $amount[$index];
                print "Bills for $index: \n";
                for my $bills ( @{$elem}) {
                  my $total_notes = $bills->{total_notes};
                  delete $bills->{total_notes};
                  print " [\n";
                  for (sort { $b <=> $a } keys %{$bills}) {
                    print "   bill $_ times $bills->{$_}\n";
                  }
                  print "   total bills $total_notes\n ]\n\n";
                  $bills->{total_notes} = $total_notes;
                }
            }
            else { print "No change available in the cashier.\n" }
          }
          
          print "type \"done\" to finish: ";
          my $var = <STDIN>;
          no warnings qw/uninitialized/;
          print "\e[2J", "\e[0;0H" and redo ITEMS if $var =~ /done/i;
          say if not defined $var;
        }
        redo;
      }
    }
  }  
}

sub sum_items {
  my ($string, $loop, $round)  = @_;
  $round = "%.0f" unless defined $round;
  while (1) {
    print $string;
    my $var = <STDIN>;
    {
      no warnings qw/uninitialized exiting/;
      unless (defined $var) {
        say and goto $loop;
      }
      elsif ($var =~ /done/i) {
        print "\e[2J", "\e[0;0H" and redo ITEMS;
      }
    }
    chomp $var;        
    my @arr =  $var =~ /(?:[^,]\d++(?:,\d{3})+|\d++(?:\.\d+)?|\.\d+)e?/ig;
    redo unless @arr;
    my $sum;
    for (@arr) {
      tr/,//d;
      if ( /e/i ) {
        tr/eE//d;
        $_ *= $euro2dollar;
      }
      $sum += $_;
    }
    return (sprintf $round, $sum), \@arr;
  }
}

sub convert_coin {
  my $string  = shift;
HERE: while (1) {
    print $string;
    my $var = <STDIN>;
    {
      no warnings qw/uninitialized exiting/;
      printf "\r" and redo COIN unless defined $var;
    }
    chomp $var;
    return ( $euro2dollar, 1 / $euro2dollar) if $var =~ /^\s*$/ and $euro2dollar != 0;

    my ($rate) = $var =~ /((?:\d*?\.\d+)|(?:\d+(?:\.\d*)?))/;
    {
      no warnings 'uninitialized';
      $rate > 0 ? return ( $rate+0, 1 / $rate)  : redo HERE;
    }
  }
}

sub number_items {
  my $string  = shift;
HERE: while (1) {
    print $string;
    my $var = <STDIN>;
    {
      no warnings qw/uninitialized exiting/;
      say and redo COIN unless defined $var;
    }
    chomp $var;
    
    my ($num) = $var =~ /((?:\-|\+)?\d+)/;
    {
      no warnings 'uninitialized';
      $num > 0 || ! defined $num ? return $num : redo HERE;
    }
  }
}

sub return_values {
  my %hash;
  my $total_notes;
  for (keys %bill) {  
    if ($bill{$_}->{value} > 0) {
      $total_notes += $bill{$_}->{value};
      $hash{$_} = $bill{$_}->{value};
    }
  }
  $hash{total_notes} = $total_notes;
  return \%hash;
}

=pod
 
=head1 Script to calculate purchased items' final cost after entering a discount amount
=cut
=head1 It also returns the change for the customer as also the best combination of notes (bills) to give to the customer
 
At any time one can enter CTRL-D to return to the previous prompt
 
=cut
