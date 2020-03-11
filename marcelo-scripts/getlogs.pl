#!/usr/bin/env perl 

use strict;
use warnings;
use Expect;

my $ssh_timeout= 10;
my $ssh_cmd = '/usr/bin/ssh'; 
my $ssh_args1 = qq(CheckHostIP=no UserKnownHostsFile=/dev/null StrictHostKeyChecking=no ConnectTimeout=$conntimeo);
my @ssh_args2 = qw/-M -q -t/;
my $ssh_arg3 = q("PS1='_prompt_ ' PS2= HISTFILE= /bin/bash --noediting --noprofile --norc");

@ssh_args1 = map { '-o', $_ }  split ' ', $ssh_args1;

push @ssh_args1, '-o', "ControlPath=$tmpdir/%h-%p-%r";

my $user = 'sv10g';
my $server = 'localhost';

# create an Expect object by spawning another process
my $exp = Expect->spawn($ssh_cmd, @ssh_args2, @ssh_args1, $user . '@' . $server, $ssh_arg3);
  or die "Cannot spawn $ssh_cmd: $!\n";
 
# send some string there:
$exp->send("string\n");
 
# or, for the filehandle mindset:
print $exp "string\n";
 
# then do some pattern matching with either the simple interface
$patidx = $exp->expect($timeout, @match_patterns);
 
# or multi-match on several spawned commands with callbacks,
# just like the Tcl version
$exp->expect(10,
           [ qr/<[Pp]assword:/ => sub { my $exp = shift;
                     $exp->send($password . "\n");
                     exp_continue; } ]
          );
 
# if no longer needed, do a soft_close to nicely shut down the command
$exp->soft_close();
 
# or be less patient with
$exp->hard_close();
