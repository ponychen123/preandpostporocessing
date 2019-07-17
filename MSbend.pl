#!perl
#20190717 add surpport for system not rightly alined to Cartesian coordination of MS
#this script bend a film along X or Y axis with a specific angle
#ponychen;
#20190703
#email:18709821294@outlook.com

use strict;
use Getopt::Long;
use MaterialsScript qw(:all);

#only two parameters you need specify
my $axis = "X";   #for the sake of simplify, only support bend along X axis or Y axis
my $inifile = "20-1";  #you file containg film to bend
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

#get the crystal axis cartesian coordination
my @corx;
my @cory;
my @corz;
for(my $i=0;$i<$atoms->Count; ++$i){
    $corx[$i] = $lattice->LengthA*@$atoms[$i]->FractionalXYZ->X;
    $cory[$i] = $lattice->LengthB*@$atoms[$i]->FractionalXYZ->Y;    
    $corz[$i] = $lattice->LengthC*@$atoms[$i]->FractionalXYZ->Z;}

#the tuple for crystal coordination
my @fracx;
my @fracy;
my @fracz;

#get the coordination matrix of three bias axis
my @vec;
    $vec[0] = $inidoc->SymmetryDefinition->VectorA->X;
    $vec[1] = $inidoc->SymmetryDefinition->VectorB->X;
    $vec[2] = $inidoc->SymmetryDefinition->VectorC->X;
    $vec[3] = $inidoc->SymmetryDefinition->VectorA->Y;
    $vec[4] = $inidoc->SymmetryDefinition->VectorB->Y;
    $vec[5] = $inidoc->SymmetryDefinition->VectorC->Y;
    $vec[6] = $inidoc->SymmetryDefinition->VectorA->Z;
    $vec[7] = $inidoc->SymmetryDefinition->VectorB->Z;
    $vec[8] = $inidoc->SymmetryDefinition->Vectorc->z;

#get the min and max value of Z direction
my $minZ = $corz[0]; 
my $maxZ = $corz[0];
foreach my $cor (@corz){
    if($cor < $minZ){
        $minZ = $cor;}
    if($cor > $maxZ){
        $maxZ = $cor;}}     

#start to bend
if($axis eq "Y"){
    my $gamma = $angle/360*2*$pi;
    my $R = $lattice->LengthA/$gamma; #get the radius of rolled tube
    
    my $i = 0;
    foreach my $atom (@$atoms){
        my $theta = $gamma*$atom->FractionalXYZ->X;
        $fracx[$i] = (($R-($corz[$i]-$minZ))*cos($theta-$pi/2)+$lattice->LengthA/2)/$lattice->LengthA;
        $fracy[$i] = $atom->FractionalXYZ->Y;
        $fracz[$i] = (($R-($corz[$i]-$minZ))*(1+sin($theta-$pi/2))+($corz[$i]-$minZ)+$lattice->LengthC/2-$R)/$lattice->LengthC;
        $i = $i + 1}
        
    my $m = 0;   
    #transfer the fractional XYZ to cartesian, due to the fact that the atoms coordination in xsd file can only be updated by set the cartesian coordination of specific atom 
    foreach my $atom (@$atoms){
        $atom->X = $fracx[$m]*$vec[0] + $fracy[$m]*$vec[1] + $fracz[$m]*$vec[2];
        $atom->Y = $fracx[$m]*$vec[3] + $fracy[$m]*$vec[4] + $fracz[$m]*$vec[5];
        $atom->Z = $fracx[$m]*$vec[6] + $fracy[$m]*$vec[7] + $fracz[$m]*$vec[8];
        $m = $m + 1}}    
elsif($axis eq "X"){     
    my $gamma = $angle/360*2*$pi;
    my $R = $lattice->LengthB/$gamma;

    my $i = 0;
    foreach my $atom (@$atoms){
        my $theta = $gamma*$atom->FractionalXYZ->Y;
        $fracy[$i] = (($R-($corz[$i]-$minZ))*cos($theta-$pi/2)+$lattice->LengthB/2)/$lattice->LengthB;
        $fracx[$i] = $atom->FractionalXYZ->x;
        $fracz[$i] = (($R-($corz[$i]-$minZ))*(1+sin($theta-$pi/2))+($corz[$i]-$minZ)+$lattice->LengthC/2-$R)/$lattice->LengthC;
        $i = $i + 1}
        
    my $m = 0;   
    #transfer the fractional XYZ to cartesian, due to the fact that the atoms coordination in xsd file can only be updated by set the cartesian coordination of specific atom 
    foreach my $atom (@$atoms){
        $atom->X = $fracx[$m]*$vec[0] + $fracy[$m]*$vec[1] + $fracz[$m]*$vec[2];
        $atom->Y = $fracx[$m]*$vec[3] + $fracy[$m]*$vec[4] + $fracz[$m]*$vec[5];
        $atom->Z = $fracx[$m]*$vec[6] + $fracy[$m]*$vec[7] + $fracz[$m]*$vec[8];
        $m = $m + 1}}    
else{
    print "please reset $axis, only support X or Y for convernence!!!\n"}                          