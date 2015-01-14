#!/usr/bin/perl 

use strict;
use warnings;

use Rent();

#Used for clearing the password after entering it.
use POSIX();
use Term::Cap;

my $termios = POSIX::Termios->new;
my $term = Term::Cap->Tgetent( { OSPEED => $termios->getospeed } );
my $arch = (POSIX::uname())[4];
my $clear_eol = $term->Tputs('ce','1','');
my $up_one_line =  $term->Tputs('up','1','');
###################################################


$SIG{'INT'} = sub { exit 1 };

my $email = '';
my $password = '';


while ($email !~ /^[^@\s]+@[^@\s]+$/ ){
  print "Enter email address: ";
  chomp($email = <STDIN>);
}

while ($password =~ /^\s*$/ ){
  print "Enter password: ";
  chomp($password = <STDIN>);
}

print $up_one_line, "Enter password: ", $clear_eol, "\n";

my %childhash;
if ( ! do { my $pid = fork; $childhash{$pid} = "yad2"; $pid } ){
    my $obj = Rent->new("yad2");
    
    $obj->login($email,$password) or die "Unable to login" unless $obj->islogged;
    #$obj->jump(14700); #Run once then sleep for 4h and 5min and loop

}elsif( ! do { my $pid = fork; $childhash{$pid} = "winwin"; $pid } ){
    my $obj = Rent->new("winwin");
    
    $obj->login($email,$password) or die "Unable to login" unless $obj->islogged;
    #$obj->keepmein;
    #$obj->jump(22200); #Run once then sleep for 6h and 10min and loop

}else{
   #I am the parent of the childs
   while ( (my $kid = wait) > 0 ){
     print "child '$childhash{$kid}:$kid' died\n";
   }
}
