#!/usr/bin/env perl

use strict;
use warnings;
use Storable qw(dclone);

my ($interface,$address,$sshport,$tunserver,$tunclient) = ('') x 5;

while ($tunserver =~ /^\s*$/ ){
  print "Enter server's tunnel interface address: ";
  $tunserver = <STDIN>;
}

while ($tunclient =~ /^\s*$/ ){
  print "Enter client's tunnel interface  address: ";
  $tunclient = <STDIN>;
}


while ($sshport =~ /^\s*$/ ){
  print "Enter ssh port number: ";
  $sshport = <STDIN>;
}

for ($tunserver, $tunclient, $sshport){
	chomp $_;
	s/\s+//g;
}

my @portuple_s = ('--dport', $sshport, qw/-m multiport --sports 1024:65535/);
my @portuple_d = @portuple_s;
@portuple_d[0,4] = qw/--sport --dports/;

my @highport_s = qw/-m multiport --sports 1024:65535/;
my @highport_d = @highport_s;
$highport_d[2] = '--dports';

my $github = '192.30.253.112';
my $git_sv_gnu_org = '208.118.235.201';
my @hosts_port22 = ($github);
my @hosts_port9418 = ($git_sv_gnu_org);

#Get interface name with default gw route
OUT: for (qx#ip route show default#){
	if (/^default.+\s+(\S+)/){
		$interface = $1;
		#Get address of that interface name
		for (qx#ip addr show $interface#){
			$address = $1 and last OUT if m#^\s*inet\s+(\S+)/\d+#; 
		}
		die "Unable to find address for $interface";
	}
	die "Unable to find default interface";
}

my %table = ( raw => {}, mangle => {}, nat => {} );
my %table_c;

$table{raw}->{prerouting} = [
	['-s', $tunclient, '-d', $tunserver, qw/-i tun+ -p tcp/, @portuple_s],
	(map { [ '-s', $tunclient, '-d', $_, qw/-i tun+ -p tcp --dport 22/, @highport_s ]  } @hosts_port22),
	(map { [ '-s', $tunclient, '-d', $_, qw/-i tun+ -p tcp --dport 9418/, @highport_s ]  } @hosts_port9418),
	['-s', $tunclient, '-i', qw/tun+ -p tcp --dport 6667/, @highport_s],
	[qw/-i tun+/]
];

$table{raw}->{output} = [
	['-s', $tunserver, '-d', $tunclient, qw/-o tun+ -p tcp/, @portuple_d],
	[qw/-o tun+/]
];

$table{nat}->{postrouting} = [
	['-s', $tunclient, '-o', $interface]
];

$table{mangle}->{postrouting} = [
	['-d', $tunclient, qw/-o tun+ -p tcp --sport 6667/, @highport_d],
	['-s', $tunserver, '-d', $tunclient, qw/-o tun+ -p tcp/, @portuple_d],
	(map { ['-s', $_, '-d', $tunclient, qw/-o tun+ -p tcp --sport 22/, @highport_d] } @hosts_port22),
	(map { ['-s', $_, '-d', $tunclient, qw/-o tun+ -p tcp --sport 9418/, @highport_d] } @hosts_port9418),
	[qw/-o tun+/]
];

#deep copy server %table to client %table_c
%table_c = %{ dclone(\%table) };

#Convert our server rules to client rules
for my $table (keys %table_c){
	for my $chain (keys %{$table_c{$table}}){
		my $rules_ptr = $table_c{$table}->{$chain};
 		for my $rule (@$rules_ptr){
			for (keys @$rule){
				next if $rule->[$_] =~ s/^-d$/-s/;
				next if $rule->[$_] =~ s/^-s$/-d/;
				next if $rule->[$_] =~ s/--sport/--dport/;
				next if $rule->[$_] =~ s/--dport/--sport/;
			}
		}
	}
}

#Add extra rules for our client
unshift @{$table_c{raw}->{output}}, ['-s', $tunclient, qw/-o tun+ -p tcp --dport 6667/, @highport_s],
									(map { ['-s', $tunclient, '-d', $_, qw/-o tun+ -p tcp --dport 22/, @highport_s] } @hosts_port22),
									(map { ['-s', $tunclient, '-d', $_, qw/-o tun+ -p tcp --dport 9418/, @highport_s] } @hosts_port9418);



my $numkeys = keys %table;
my $type = 'server';
my %string;

{
 my $i = 0;
 for my $table (keys %table, keys %table_c){
	 my $table_href = $table{$table};
	 if (++$i > $numkeys){
		next if $table eq 'nat';
		$type = 'client';
	 	$table_href = $table_c{$table};
	}
	
	for my $chain (keys %{$table_href}){
		$string{$type} .= join " ", "\n#Flushing chain '" . uc $chain, "' table '$table' \n";
		$string{$type} .= join " ", 'iptables -t', $table, '-F', uc $chain, "\n";
		my $rules = $table_href->{$chain};
		my $command = 'ACCEPT';
		for (my $i = 0; $i < @{$rules}; $i++){
			if ($table ne 'nat'){
				$command = 'DROP' if ! ($i < (@{$rules} - 1))
			}else {
				$command = "SNAT --to-source $address";
			}
			$string{$type} .= join " ", 'iptables -t', $table, '-A', uc $chain, @{$rules->[$i]}, '-j', $command, "\n";
		}
	}
 }
}

no warnings 'uninitialized';

if ($ARGV[0] eq 'client'){
	print $string{client};
}elsif ($ARGV[0] eq 'server') {
	print $string{server};
}else{
	print "\n#Server rules\n";
	print $string{server};
	print "\n#Client rules\n";
	print $string{client};
}
