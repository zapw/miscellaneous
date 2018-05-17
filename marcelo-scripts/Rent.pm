#https://metacpan.org/pod/Devel::Trace
#Net::Async::HTTP
# search metapan or ddg for perl related stuff
package Rent;

use strict;
use warnings;

use Carp('croak');
use Scalar::Util('looks_like_number');
use Time::HiRes qw (time);
use POSIX ":sys_wait_h";
use LWP::UserAgent ();

$| = 1;

my $ua = LWP::UserAgent->new;
$ua->agent("Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/57.0.2987.133 Safari/537.36");
$ua->timeout(10);
$ua->env_proxy;
$ua->cookie_jar({ file => "$ENV{HOME}/.cookies/cookie.dat", autosave => 1 });

sub new {
	my @sites = qw/yad2 winwin/;
	my ($class,$site) = @_;
	croak "$$: Must supply value" unless defined $site;
	my $found = 0;
	for (@sites){
		if ($_ eq $site){
			$found = 1; last;
		}
	}
	{
	  local $, = " ";
	  croak "invalid: '$site', valid values '@sites'" unless $found;
	}
	bless \$site;
}

sub login {
    my ($self,$email,$password) = @_;
	my $site = $$self;
    if ($site eq "winwin"){ 
	  my $req = HTTP::Request->new(POST => 'https://www.winwin.co.il/SOA/Login.asmx/TryLogin', [ Origin => 'https://www.winwin.co.il' ]);
	  $req->content_type('application/json; charset=UTF-8');
	  $req->referer('https://www.winwin.co.il/Homepage/Page.aspx');
	  $req->content('{"username":"' . $email . '","pass":"' . $password . '","remember":"true"}');
	  $ua->request($req);

	  $req = HTTP::Request->new(POST => 'https://www.winwin.co.il/SOA/Login.asmx/IsLogged"', [ Origin => 'https://www.winwin.co.il' ]);
	  $req->content_type('application/json; charset=UTF-8');
	  $req->referer('https://www.winwin.co.il/Homepage/Page.aspx');
	  return 1 if $ua->request($req);
      return 0;

	}elsif ($site eq "yad2"){
      $email =~ s/@/%40/;

	  my $req = HTTP::Request->new(POST => 'http://my.yad2.co.il/login.php');
	  $req->content_type('application/x-www-form-urlencoded');
	  $req->content("Username=$email&Password=$password&login=");
	  my $response = $ua->request($req);
      if ( $response->redirects and (($response->redirects)[0])->header( "Location" ) eq "http://my.yad2.co.il/MyYad2/MyOrder/" ){
         return 1;
      }else{ 
         return 0;
      }
	  return 1;
	}elsif ($site eq "komo"){
      $email =~ s/@/%40/;

	  my $req = HTTP::Request->new(POST => 'https://www.komo.co.il/code/users/login.asp');
	  $req->content_type('application/x-www-form-urlencoded');
	  $req->content("r=https%3A%2F%2Fwww.komo.co.il%2Fcode%2Fusers%2Fmenu.asp&rememberme=y&atime=first&email=$email&password=$password&chkrememberme=on");
	  my $response = $ua->request($req);
      if ( $response->redirects and (($response->redirects)[0])->header( "Location" ) =~ m#^https://www.komo.co.il/code/users/# ){
         return 0;
      }else{ 
         return 1;
      }
	  return 1;
	}
}

sub islogged {
  my ($self) = @_;
  my $site = $$self;
  if ($site eq "winwin"){
	my $response = $ua->get( 'https://www.winwin.co.il/Personal/PublishedAds/RealEstate/PersonalPage.aspx' );

    if ( $response->redirects and (($response->redirects)[0])->header( "Location" ) eq "https://www.winwin.co.il/Homepage/Page.aspx" ){
       return 0;
      }else {
        return 1;
      }
   }elsif ($site eq "yad2"){
     my $response = $ua->get( 'http://my.yad2.co.il/MyYad2/MyOrder/' );
     if ( $response->redirects ){ 
        my $redirect = (($response->redirects)[0])->header( "Location" );
	if ( grep { $redirect eq $_ } ('http://my.yad2.co.il/login.php', 'http://geo.yad2.co.il') ){
       	  return 0;
	}else {
          return 1;
	}
      }
      return 1;
   }elsif ($site eq "komo"){
     my $response = $ua->get( 'https://www.komo.co.il/code/users/modaot/' );
     if ( $response->redirects ){ 
        my $redirect = (($response->redirects)[0])->header( "Location" );
		if ( grep { $redirect =~ /$_/ } ('/code/users/') ){
       	  return 0;
		}else {
          return 1;
		}
     }
     return 1;

   }
}

sub keepmein {
    my ($self) = @_;
    my $site = $$self;
    if (!defined $site) {
	  croak "must provide value";
    }elsif ($site eq "winwin"){
	  loop();
    }   
    sub loop {
       $SIG{ALRM} = \&loop;
       alarm 90;

	   my $req = HTTP::Request->new(POST => 'https://www.winwin.co.il/SOA/Login.asmx/KeepMeIn', [ Origin => 'https://www.winwin.co.il' ]);
 	   $req->content_type('application/json; charset=UTF-8');
 	   $req->referer('https://www.winwin.co.il/Personal/PublishedAds/RealEstate/PersonalPage.aspx');
 	   $ua->request($req);
    }

}

sub jump {
  my ($self,$rate) = @_;
  my $site = $$self;
  croak "'$rate' dosen't look like a number" unless looks_like_number $rate;

  my $req;
  if ($site eq "winwin"){
    do{
      $ua->get('https://www.winwin.co.il/Personal/PublishedAds/RealEstate/PersonalPage.aspx');

      $req = HTTP::Request->new(POST => 'https://www.winwin.co.il/SOA/Personal.asmx/IsAgentCanJumpAd', [ Origin => 'https://www.winwin.co.il' ]);
      $req->content_type('application/json; charset=UTF-8');
      $req->referer('https://www.winwin.co.il/Personal/PublishedAds/RealEstate/PersonalPage.aspx');
      $req->content('{"userid":1181350,"actionType":2,"adId":4330269}');
      $ua->request($req);

      {
       my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime(time);
       my $time = "$mday/" . ($mon+1) . "/" . ($year+1900) . " $hour:$min:$sec";
       $req = HTTP::Request->new(POST => 'https://www.winwin.co.il/SOA/Personal.asmx/SetDataSetChangesObjects', [ Origin => 'https://www.winwin.co.il' ]);
       $req->content_type('application/json; charset=UTF-8');
       $req->referer('https://www.winwin.co.il/Personal/PublishedAds/RealEstate/PersonalPage.aspx');
       $req->content('{"nsid":254,"objid":4330269,"date":"' . $time . '"}');
       my $response = $ua->request($req);
       print localtime(time) . ": ";
       if ($response->is_success) {
         print "WinWin: Request success\n";
       }else {
         die "WinWin: " . $response->status_line;
       }

      }
     } while (mysleep ($rate));

    }elsif ($site eq "yad2"){

      do{
  	    $ua->get( 'http://my.yad2.co.il/MyYad2/MyOrder/rent.php');

  	    $req = HTTP::Request->new(GET => 'http://my.yad2.co.il/MyYad2/MyOrder/rentDetails.php?NadlanID=3160315');
  	    $req->referer('http://my.yad2.co.il/MyYad2/MyOrder/rent.php');
  	    $ua->request($req);

  	    $req = HTTP::Request->new(GET => 'http://my.yad2.co.il/MyYad2/MyOrder/rentDetails.php?NadlanID=3160315&Up=u');
  	    $req->referer('http://my.yad2.co.il/MyYad2/MyOrder/rentDetails.php?NadlanID=3160315');
  	    my $response = $ua->request($req);
  	    print localtime(time) . ": ";
  	    if ($response->is_success) {
     		print "Yad2: Request success\n";
  	    }else {
     		die "Yad2 " . $response->status_line;
  	    }
	  } while (mysleep ($rate));

   }elsif ($site eq "komo"){

      do{
  	    $ua->get( 'http://my.yad2.co.il/MyYad2/MyOrder/rent.php');

  	    $req = HTTP::Request->new(GET => 'http://my.yad2.co.il/MyYad2/MyOrder/rentDetails.php?NadlanID=3160315');
  	    $req->referer('http://my.yad2.co.il/MyYad2/MyOrder/rent.php');
  	    $ua->request($req);

  	    $req = HTTP::Request->new(GET => 'http://my.yad2.co.il/MyYad2/MyOrder/rentDetails.php?NadlanID=3160315&Up=u');
  	    $req->referer('http://my.yad2.co.il/MyYad2/MyOrder/rentDetails.php?NadlanID=3160315');
  	    my $response = $ua->request($req);
  	    print localtime(time) . ": ";
  	    if ($response->is_success) {
     		print "Komo: Request success\n";
  	    }else {
     		die "Komo " . $response->status_line;
  	    }
	  } while (mysleep ($rate));

   }


}
sub mysleep {
  my ($rate) = @_;
  my $end = time + $rate;
  while (1) {
    my $delta = $end - time;
    return $rate if $delta <= 0;
    sleep $delta;
  }
}

1;
