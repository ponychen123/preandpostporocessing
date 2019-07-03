#!perl
#this script bend a film along X or Y axis with a specific angle
#ponychen;
#20190703
#email:18709821294@outlook.com

use strict;
use Getopt::Long;
use MaterialsScript qw(:all);

#only two parameters you need specify
my $axis = "X";   #for the sake of simplify, only support bend along X axis or Y axis
my $inifile = "test";  #you file containg film to bend
my $angle = 180;  #the bend angle (unit in Degree)

#do not change following codes unless you konw what you are doing
#read the file and get the atomic coordinations
my $inidoc = $Documents{"$inifile.xsd"};
my $findoc = Documents->New("tube.xsd");
$findoc->CopyFrom($inidoc);
my $lattice = $findoc->SymmetryDefinition;
my $atoms = $findoc->UnitCell->Atoms;

#get the constant value PI
my $pi = 4*atan2(1,1);

#start to bend
if($axis eq "Y"){
    my $gamma = $angle/360*2*$pi;
    my $R = $lattice->LengthA/$gamma; #get the radius of rolled tube
    my $minZ = @$atoms[0]->Z;  #get the min and max value of Z direction
    my $maxZ = @$atoms[0]->Z;
    foreach my $atom (@$atoms){
        if($atom->Z < $minZ){
            $minZ = $atom->Z;}
        if($atom->Z > $maxZ){
            $maxZ = $atom->Z;}}

    foreach my $atom (@$atoms){
        my $theta = $gamma*$atom->FractionalXYZ->X;
        $atom->X = ($R-($atom->Z-$minZ))*cos($theta-$pi/2)+$lattice->LengthA/2;
        $atom->Z = ($R-($atom->Z-$minZ))*(1+sin($theta-$pi/2))+($atom->Z-$minZ)+$lattice->LengthC/2-$R;}}
elsif($axis eq "X"){     
    my $gamma = $angle/360*2*$pi;
    my $R = $lattice->LengthB/$gamma;
    my $minZ = @$atoms[0]->Z;
    my $maxZ = @$atoms[0]->Z;
    foreach my $atom (@$atoms){
        if($atom->Z < $minZ){
            $minZ = $atom->Z;}
        if($atom->Z > $maxZ){
            $maxZ = $atom->Z;}}

    foreach my $atom (@$atoms){
        my $theta = $gamma*$atom->FractionalXYZ->Y;
        $atom->Y = ($R-($atom->Z-$minZ))*cos($theta-$pi/2)+$lattice->LengthB/2;
        $atom->Z = ($R-($atom->Z-$minZ))*(1+sin($theta-$pi/2))+($atom->Z-$minZ)+$lattice->LengthC/2-$R;}}
else{
    #do nothing
    last}                               