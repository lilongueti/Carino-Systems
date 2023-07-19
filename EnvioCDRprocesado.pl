#!/usr/bin/perl
# Avaya Aura

use Time::Local; use POSIX qw/strftime/; my ($s, $min, $h, $d, $m, $y) = localtime();
my $FechaX      = strftime "%Y%m%d", $s, $min, $h, $d - 1, $m, $y;

$PathBin        = "/home/sittel/bin/";
$PathLocal1     = "/home/sittel/Sitios/rawdata/";
$PathLocal2     = "/home/sittel/Sitios/gz/";
$PathLocal3     = "/home/sittel/Sitios/gzraw/";
$NameFile1      = "depNortel.pl";
$NameFile2      = "avayaaura.";
$NameFile3      = "tmp1.";
$NameFile4      = "filtra.pl";
$NameFile5      = "immstrip1.pl";
$NameFile6      = "cuprumaura2.";
$FinalFile1     = "$NameFile2$FechaX";
$FinalFile2     = "$NameFile3$FechaX";
$FinalFile3     = "$NameFile6$FechaX";
$PathRemote1    = "Cuprum/AURA1/";
$PathRemote2    = "Cuprum/AURA1/gzraw/";

system("$PathBin$NameFile1 $PathLocal1$FinalFile1 > $PathLocal1$FinalFile2");
system("perl $PathBin$NameFile4 $PathLocal1$FinalFile2 > ${PathLocal1}tmp.${FechaX}");
system("$PathBin$NameFile5");
system("gzip $PathLocal2$FinalFile3");
system("rm $PathLocal1$FinalFile2");
system("gzip $PathLocal1$FinalFile1");
system("mv ${PathLocal1}${FinalFile1}.gz $PathLocal3");
system("rm  ${PathLocal1}tmp.${FechaX}");
system("/home/sittel/bin/sndFtp2 192.168.1.155 sittel sittel k3yt1azeus $FinalFile3.gz $PathLocal2 $FinalFile3.gz $PathRemote1");
system("/home/sittel/bin/sndFtp2 192.168.1.155 sittel sittel k3yt1azeus $FinalFile1.gz $PathLocal3 $FinalFile1.gz $PathRemote2");