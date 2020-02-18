use Test2::V0 -no_srand => 1;
use Test::Alien 0.11;
use Alien::curl;

alien_ok 'Alien::curl';

subtest 'command line' => sub {

  my $run = run_ok(['curl', '--version']);
  $run->success;
  $run->out_like(qr/curl/);

  my($protocols) = $run->out =~ /^Protocols:\s*(.*)\s*$/m;
  my %protocols = map { $_ => 1 } split /\s+/, $protocols;

  is(
    \%protocols,
    hash {
      field http  => T();
      field https => T();
      field ftp   => T();
      etc;
    },
    'protocols supported incudes: http, https, and ftp',
  ) || diag $run->out;

};

xs_ok(
  do { local $/; <DATA> },
  with_subtest {
    my $version = Curl::curl_version();
    ok $version, "version returned ok";
    note "version = $version";
  }
);

done_testing;

__DATA__
#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"
#include <curl/curl.h>

MODULE = Curl PACKAGE = Curl

const char *
curl_version()
