#!/usr/bin/perl
use strict;

# IS Jobs stats
# Martin Colello
# 04/2010

# Zabbix-Compatible
# Mark Taguiad
# 07/2022

my $hostname;
my $url;


$hostname = $ARGV[0];

$url = "http://$hostname:5555/invoke/WmSysAdmin.monitors.resources:getStatistics?type=session";

my $machine  = "$hostname,amkor,com";
my $curl     = '/usr/bin/curl -s --max-time 5 --connect-timeout 5';
my $color    = 'GREEN';
my $report;
my $one;
my $two;
my $three;

my @data = geturl($url);


foreach(@data){
  my $line = $_;
  if ( $line =~ '<output>' ) {
    $line =~ /\<output\>(.*)\,(.*)\,(.*)\<\/output\>/;
    ($one,$two,$three)=($1,$2,$3);

    $report .= sprintf ( "%-20s %-10s %10s", $one, $three, $two."%" );
    $report .= "\n";
    
  }
}


$report = "$report";
if ( $report ) {
  my $line    = "$report";

print "$line\n";

}

sub geturl {
  my $url     = shift;
  my @results = `$curl $url`;
  return @results;
}
