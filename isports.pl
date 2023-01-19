#!/usr/bin/perl
use strict;

# IS Jobs stats
# Martin Colello
# 04/2010

# Zabbix-Compatible
# Mark Taguiad
# 07/2022

my $hostname;
my $disable;
my $url;


$hostname = $ARGV[0];
$disable = $ARGV[1];

$url = "http://$hostname:5555/invoke/WmSysAdmin.monitors.component.ports:getStatus";

my $machine  = "$hostname,amkor,com";
my $curl     = '/usr/bin/curl -s --max-time 5 --connect-timeout 5';
my $color    = 'GREEN';
my $report   = "\n";
my $one;
my $two;
my $three;

my @data = geturl($url);


foreach(@data){
  my $line = $_;
  if ( $line =~ '<output>' ) {
    $line =~ /<output>(\S+),(\S+),(\S+)<\/output>/;
    ($one,$two,$three)=($1,$2,$3);

    #$report .= sprintf ( "%-122s %-38s %-20s", $one, $two, $three );
    #$report .= "\n";
    unless ( $one =~ /$disable/) {
      if ( $three !~ /^active/ ) {
        $color = 'RED';
        $report .= sprintf ( "%-75s %-15s %-20s", $one, $two, $three );
        $report .= "\n";
      }
    }

    
  }
}


$report = "$report";
if ( $report ) {
  my $line    = "Status: $color\n $report";

print "$line\n";

}

sub geturl {
  my $url     = shift;
  my @results = `$curl $url`;
  return @results;
}
