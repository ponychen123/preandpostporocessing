#!perl
#20190612fix bugs and now will output the result to a new file
#this script color atoms by their coordinations
#ponychen
#20190605
#email:18709821294@outlook.com

use strict;
use Getopt::Long;
use MaterialsScript qw(:all);
use POSIX;

#the only parameter you need chage
my $direction = "b";      #a or b or c means the crystal direction pertenticulay to your oberseving plane
my $filename = "ribbon1"; #xsd file name

#do not change following codes unles you know what you are doing 
my $olddoc = $Documents{"$filename.xsd"};
my $doc = Documents->New("new$filename.xsd");
   $doc->Copyfrom($olddoc);

my $lattice = $doc->SymmetryDefinition;

#sort all atoms by one of its direct coordination
my $atoms = $doc->UnitCell->Atoms;

#bulid own colormap with11 level
my %mycolormap = (0=>"145 44 238",1=>"255 255 255",2=>"47 79 79",3=>"105 105 105",4=>"0 0 255",5=>"0 206 209",6=>"0 255 0",7=>"255 255 0", 8=>"205 92 92",9=>"255 0 0",10=>"105 89 205");

#change atom color by ordination
if ($direction eq "c"){
my @sortedAt = sort {$a->FractionalXYZ->Z <=> $b->FractionalXYZ->Z} @$atoms;
my $distol = $sortedAt[-1]->FractionalXYZ->Z - $sortedAt[0]->FractionalXYZ->Z;

foreach my $atom (@sortedAt){
    my $disatom = ceil(($atom->FractionalXYZ->Z - $sortedAt[0]->FractionalXYZ->Z)/$distol*10);
     my @a = split(" ",$mycolormap{$disatom});
    $atom->Color=RGB($a[0],$a[1],$a[2]);
}}    
elsif ($direction eq "b"){
my @sortedAt = sort {$a->FractionalXYZ->Y <=> $b->FractionalXYZ->Y} @$atoms;
my $distol = $sortedAt[-1]->FractionalXYZ->Y - $sortedAt[0]->FractionalXYZ->Y;

foreach my $atom (@sortedAt){
    my $disatom = ceil(($atom->FractionalXYZ->Y - $sortedAt[0]->FractionalXYZ->Y)/$distol*10);
     my @a = split(" ",$mycolormap{$disatom});
    $atom->Color=RGB($a[0],$a[1],$a[2]);
}}  
else{
my @sortedAt = sort {$a->FractionalXYZ->X <=> $b->FractionalXYZ->X} @$atoms;
my $distol = $sortedAt[-1]->FractionalXYZ->X - $sortedAt[0]->FractionalXYZ->X;

foreach my $atom (@sortedAt){
    my $disatom = ceil(($atom->FractionalXYZ->X - $sortedAt[0]->FractionalXYZ->X)/$distol*10);
     my @a = split(" ",$mycolormap{$disatom});
    $atom->Color=RGB($a[0],$a[1],$a[2]);
}} 
