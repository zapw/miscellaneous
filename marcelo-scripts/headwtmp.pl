#!/usr/bin/perl 
#===============================================================================
#
#         FILE:  tailwtmp.pl
#
#        USAGE:  ./tailwtmp.pl  
#
#  DESCRIPTION:  
#
#      OPTIONS:  ---
# REQUIREMENTS:  ---
#         BUGS:  ---
#        NOTES:  ---
#       AUTHOR:  Dr. Fritz Mehner (mn), mehner@fh-swf.de
#      COMPANY:  FH Südwestfalen, Iserlohn
#      VERSION:  1.0
#      CREATED:  07/17/2019 10:59:00 AM
#     REVISION:  ---
#===============================================================================

use strict;
use warnings;
use IO::File;

#https://metacpan.org/pod/distribution/perl/pod/perlpacktut.pod
#l< is the login date in seconds since the epoch (1970-01-01 UTC)
#the second c32 is the username it can't be null, if it is go to next entry
#format:
#bytes: 44      32       264     4     40
#      BEGIN  username  empty   time  END
#
my $typedef = '';
my $sizeof = length pack($typedef, ( ) );

my $buffer;
my @wtmp;

open(my $wtmp_fh, "< :raw", "/var/log/wtmp") or die "can't open /var/log/wtmp: $!";
seek($wtmp_fh, -$sizeof, SEEK_END);
my ($before, $after);

while (read($wtmp_fh, $buffer, $sizeof) == $sizeof) {
   @wtmp = unpack($typedef,$buffer);
   $before = tell($wtmp_fh);
   seek($wtmp_fh, 2 * -$sizeof, SEEK_CUR);
   $after = tell($wtmp_fh);
   last if $before == $after;
   print $wtmp[-3], "\n";
}


=begin
           #define EMPTY         0 /* Record does not contain valid info
                                      (formerly known as UT_UNKNOWN on Linux) */
           #define RUN_LVL       1 /* Change in system run-level (see
                                      init(8)) */
           #define BOOT_TIME     2 /* Time of system boot (in ut_tv) */
           #define NEW_TIME      3 /* Time after system clock change
                                      (in ut_tv) */
           #define OLD_TIME      4 /* Time before system clock change
                                      (in ut_tv) */
           #define INIT_PROCESS  5 /* Process spawned by init(8) */
           #define LOGIN_PROCESS 6 /* Session leader process for user login */
           #define USER_PROCESS  7 /* Normal process */
           #define DEAD_PROCESS  8 /* Terminated process */
           #define ACCOUNTING    9 /* Not implemented */

           #define UT_LINESIZE      32
           #define UT_NAMESIZE      32
           #define UT_HOSTSIZE     256

           struct exit_status {              /* Type for ut_exit, below */
               short int e_termination;      /* Process termination status */
               short int e_exit;             /* Process exit status */
           };

           struct utmp {
               short   ut_type;              /* Type of record */
               pid_t   ut_pid;               /* PID of login process */
               char    ut_line[UT_LINESIZE]; /* Device name of tty - "/dev/" */
               char    ut_id[4];             /* Terminal name suffix,
                                                or inittab(5) ID */
               char    ut_user[UT_NAMESIZE]; /* Username */
               char    ut_host[UT_HOSTSIZE]; /* Hostname for remote login, or
                                                kernel version for run-level
                                                messages */
               struct  exit_status ut_exit;  /* Exit status of a process
                                                marked as DEAD_PROCESS; not
                                                used by Linux init (1 */
               /* The ut_session and ut_tv fields must be the same size when
                  compiled 32- and 64-bit.  This allows data files and shared
                  memory to be shared between 32- and 64-bit applications. */
           #if __WORDSIZE == 64 && defined __WORDSIZE_COMPAT32
               int32_t ut_session;           /* Session ID (getsid(2)),
                                                used for windowing */
               struct {
                   int32_t tv_sec;           /* Seconds */
                   int32_t tv_usec;          /* Microseconds */
               } ut_tv;                      /* Time entry was made */
           #else
                long   ut_session;           /* Session ID */
                struct timeval ut_tv;        /* Time entry was made */
           #endif

               int32_t ut_addr_v6[4];        /* Internet address of remote
                                                host; IPv4 address uses
                                                just ut_addr_v6[0] */
               char __unused[20];            /* Reserved for future use */

