#!/usr/bin/perl
use strict;

# IS Jobs stats
# Martin Colello
# 04/2010

# Zabbix-Comaptible
# Mark Taguiad
# 07/2022

my $hostname;
my $url;


$hostname = $ARGV[0];

$url = "http://$hostname:5555/invoke/WmSysAdmin.monitors.connections.JMS:getStatus";

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
    $line =~ /\<output\>(.*)\,(.*)\,(.*)\<\/output\>/;
    ($one,$two,$three)=($1,$2,$3);

    #$report .= sprintf ( "%-30s %-10s %10s", $one, $two, $three );
    #$report .= "\n";

    if ( $two =~ /false/ ) {
      $color = 'RED';
      $report .= sprintf ( "%-30s %-10s %10s", $one, $two, $three );
      $report .= "\n";
      #$report .= "\n\nJMS Connection Disabled. Please contact ESB Support.\n\n" unless ($report =~ /Please contact ESB Support/) ;
    }
    if ( $three > 0 ) {
      $color = 'RED';
      $report .= sprintf ( "%-30s %-10s %10s", $one, $two, $three );
      $report .= "\n";
      #$report .= "\nMessages Pending at Client Side Queue for Connection: $one  Please contact ESB Support.\n\n\n";
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
