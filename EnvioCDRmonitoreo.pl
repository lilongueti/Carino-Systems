#!/usr/bin/perl

use Time::Local; use POSIX qw/strftime/; my ($s, $min, $h, $d, $m, $y) = localtime();
my $FechaX      = strftime "%Y%m%d", $s, $min, $h, $d, $m, $y;

$PathLocal1     = "/home/sittel/Sitios/rawdata/";
$PathLocal2     = "/home/sittel/Sitios/gzraw/diario/";
$NameFile       = 'avayaaura.';
$FinalFile      = "$NameFile$FechaX";
$PathRemote     = "Cuprum/AURA1/diario1/";

system("cp $PathLocal1$FinalFile $PathLocal2");
system("gzip $PathLocal2$FinalFile");
system("/home/sittel/bin/sndFtp2 192.168.1.155 sittel sittel k3yt1azeus $FinalFile.gz $PathLocal2 $FinalFile.gz $PathRemote");
system ("rm ${PathLocal2}${FinalFile}.gz");

exit 0;
