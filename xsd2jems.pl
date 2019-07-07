#!perl
#xsd2jems.pl v1.2, add support for fractional sited atoms and ingnore the symmetry to avoid bugs in jems. 20190707
#xsd2jems.pl v1.1, fixed the wrong format of occupancy and Deby factor, 11/28/2018
#xsd2jems.pl v1.0, Author: Chunjin Chen at IMR, cjchen16s@imr.ac.cn
#11/25/2018
#This is a perl script for converting the Materials studio xsd file to the jems crystal file for JEMS.
#Usage: Change the $filename variable to you xsd file, and it will generate a $filename.txt jems file in the JEMS format. you can just export it in txt format.
#Attention: the occupancy and Debye–Waller factor are reading from xsd file, and photoabsorption coefficient is set to 0.03, you can change it in
#           $absorption value
#this script was modificated from professor Yan Zhao's script sxd2poscar, yan2000@whut.edu.cn

use strict;
use Getopt::Long;
use MaterialsScript qw(:all);

my $filename = "Ni3Ti";                                                       #change your filename that should be in the same ducument
my $doc = $Documents{"$filename.xsd"};
my $jems = Documents->New("$filename.txt");
my $lattice = $doc->SymmetryDefinition;
my $lat = "lattice";

my $absorption = 0.03 ;                                                    #adjust if necesary
my $Debye = 0.00 ;
my @element;
my @num_atom;
my $ele;
my $num;

my $sol = "triclinic";

$jems->Append(sprintf "$filename \n");
$jems->Append(sprintf "%s|%s \n","system",$sol);
$jems->Append(sprintf "HMSymbol|1|1|0|0| P 1\n");
$jems->Append(sprintf "rps|0| x , y , z \n");
$jems->Append(sprintf "%s|%s|%.4f \n",$lat,"0",$lattice->LengthA/10);       # it should be noted that in jems format file the default distance value 
$jems->Append(sprintf "%s|%s|%.4f \n",$lat,"1",$lattice->LengthB/10);       # is nm,  unlike other format input file.
$jems->Append(sprintf "%s|%s|%.4f \n",$lat,"2",$lattice->LengthC/10);
$jems->Append(sprintf "%s|%s|%.4f \n",$lat,"3",$lattice->AngleAlpha);
$jems->Append(sprintf "%s|%s|%.4f \n",$lat,"4",$lattice->AngleBeta);
$jems->Append(sprintf "%s|%s|%.4f \n",$lat,"5",$lattice->AngleGamma);

#this section account the species of elements and atom total numbers of each specie. For later use.
my $atoms = $doc->UnitCell->Atoms;

my @sortedAtom = sort {$a->AtomicNumber <=> $b->AtomicNumber} @$atoms;

my $count_el = 0;
my $count_atom = 0;
   $element[0] = $sortedAtom[0]->ElementSymbol;
my $atom_num = $sortedAtom[0]->AtomicNumber;

foreach my $atom (@sortedAtom){
  if ($atom->AtomicNumber == $atom_num){
    $count_atom = $count_atom + 1;
    } else {
      $num_atom[$count_el] = $count_atom;
      $count_atom = 1;
      $count_el = $count_el + 1;
      $element[$count_el] = $atom->ElementSymbol;
      $atom_num = $atom->AtomicNumber;
      }
    }
$num_atom[$count_el] = $count_atom;

#this format is not the standard format described in JEMS manual, but it looks more elegant and worked well in JEMS.
#Attention: JEMS crystal file only surport Fractional axis.
my $i = 0;
foreach my $atom (@$atoms){
   my $composition = $atom->Composition;
   my @com = split(/;/, $composition);
   if (@com > 1){
   	foreach my $com2 (@com){
   	    my @com3 = split(/,/, $com2);
   	    my $elementsymbol = $com3[0];
            my $occupancy = $com3[1];
   	    $jems->Append(sprintf "%s|%u|%s,%s,%.4f,%.4f,%.4f,%.5f,%.5f,%.5f \n", "atom",$i,$elementsymbol,"a",$atom->FractionalXYZ->X,
   	    $atom->FractionalXYZ->Y,$atom->FractionalXYZ->Z,$Debye,$occupancy,$absorption);
   	    $i ++;
       }}
   else{
       my $elementsymbol = @com[0];
       my $occupancy = 1.00000;
       $jems->Append(sprintf "%s|%u|%s,%s,%.4f,%.4f,%.4f,%.5f,%.5f,%.5f \n", "atom",$i,$elementsymbol,"a",$atom->FractionalXYZ->X,
       $atom->FractionalXYZ->Y,$atom->FractionalXYZ->Z,$Debye,$occupancy,$absorption);
       $i ++;}}       
      






