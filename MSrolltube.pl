#!perl
#this script roll a film along X or Y axis 
#ponychen
#20190703
#email:18709821294@outlook.com

use strict;
use Getopt::Long;
use MaterialsScript qw(:all);

#only two parameters you need specify
my $axis = "X";   #for the sake of simplify, only support roll along X axis or Y axis
my $inifile = "test";  #you file containg film to roll

#do not change following codes unless you konw what you are doing
#read the file and get the atomic coordinations
my $inidoc = $Documents{"$inifile.xsd"};
my $findoc = Documents->New("tube.xsd");
$findoc->CopyFrom($inidoc);
my $lattice = $findoc->SymmetryDefinition;
my $atoms = $findoc->UnitCell->Atoms;

#get the constant value PI
my $pi = 4*atan2(1,1);

#start to roll
if($axis eq "Y"){
    my $R = $lattice->LengthA/(2*$pi); #get the radius of rolled tube
    my $minZ = @$atoms[0]->Z;  #get the min and max value of Z direction
    my $maxZ = @$atoms[0]->Z;
    foreach my $atom (@$atoms){
        if($atom->Z < $minZ){
            $minZ = $atom->Z;}
        if($atom->Z > $maxZ){
            $maxZ = $atom->Z;}}

    foreach my $atom (@$atoms){
        my $theta = 2*$pi*$atom->FractionalXYZ->X;
        $atom->X = ($R-($atom->Z-$minZ))*cos($theta-$pi/2)+$lattice->LengthA/2;
        $atom->Z = ($R-($atom->Z-$minZ))*(1+sin($theta-$pi/2))+($atom->Z-$minZ)+$lattice->LengthC/2-$R;}}
elsif($axis eq "X"){ 
    my $R = $lattice->LengthB/(2*$pi);
    my $minZ = @$atoms[0]->Z;
    my $maxZ = @$atoms[0]->Z;
    foreach my $atom (@$atoms){
        if($atom->Z < $minZ){
            $minZ = $atom->Z;}
        if($atom->Z > $maxZ){
            $maxZ = $atom->Z;}}

    foreach my $atom (@$atoms){
        my $theta = 2*$pi*$atom->FractionalXYZ->Y;
        $atom->Y = ($R-($atom->Z-$minZ))*cos($theta-$pi/2)+$lattice->LengthB/2;
        $atom->Z = ($R-($atom->Z-$minZ))*(1+sin($theta-$pi/2))+($atom->Z-$minZ)+$lattice->LengthC/2-$R;}}
else{
    #do nothing
    last}                               