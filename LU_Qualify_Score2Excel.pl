#!/usr/bin/perl
#
use Spreadsheet::WriteExcel;

my $file= $ARGV[0];
my $toExcel = $ARGV[1];

my $workbook = Spreadsheet::WriteExcel->new($toExcel);
my $worksheet = $workbook->add_worksheet();


open(FH, "<$file") or die "Cannot open file $file $!\n";

my $format = $workbook->add_format();
$format->set_pattern();
$format->set_bg_color(0x1D);

my ($x,$y) = (0,0);
my $type=0;

while(<FH>){
  chomp;
  @lst = split /\t/,$_;
  foreach my $c (@lst){
    if($type==0 && ($y==3||$y==4) && $c < 0.90){
      $worksheet->write($x,$y, $c, $format);
    } elsif ($type==2 && $y==1 && $c < 0.90) {
      $worksheet->write($x,$y, $c, $format);
    } elsif ($type==3 && $y==3) {
      if($c =~ /(\d+\.\d+)%/){
        $c=$1/100;
      }
      if($c < 0.85 ){
        $worksheet->write($x,$y, $c, $format);
      }else{
        $worksheet->write($x,$y, $c);
      }
    } else {
      $worksheet->write($x,$y, $c);
    }
    $y++;
  }
  if((scalar @lst) < 1){
    $type ++;
  } 
  $x++;
  $y=0;
}
close(FH);
$workbook->close();
