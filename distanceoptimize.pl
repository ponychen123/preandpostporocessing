#!perl
#this script roughly optimize the structure to avoid any two atoms meeting too closely. experimently use, funny and roughly code.
#usage: change the filename in $inifile to your xsd file and run
#ponychen
#email:18709821294@outlook.com
#20190702
use strict;
use Getopt::Long;
use MaterialsScript qw(:all);

#some parameters you can set
my $inifile = "00";   #the filename of xsd file
my $dmin = 2.3;       #belowe which the atoms are thought to be close, unit angstrom
my $dd = 0.5;         #the step size in optmize
my $maxitr = 100;     #the maximum iteration for each cycle in optimization.
my $A = 2;            #the amplitude of weight function A/d^-N
my $N = 4;            #the power of weight function A/d^-N

#do not change following codes unless you konw what you are doing !!!
my $inidoc = $Documents{"$inifile.xsd"};
my $findoc = Documents->New("opted.xsd");
$findoc->CopyFrom($inidoc);
my $a = $findoc->UnitCell->Atoms;

#get 9 component of axis of cell
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

my $dmin2 = $dmin**2;
my $de = 1;
my $itr = 0;
my @adx; my @ady; my @adz; my @newadx; my @newady; my @newadz; 

#start the loop
while($de > 0){
    #initialize
    $de = 0;
    for(my $m=0; $m<$a->Count; ++$m){ 
        $adx[$m] = 0; $ady[$m] = 0; $adz[$m] = 0;
        for(my $n=0; $n<$a->Count; ++$n){
            if( $n == $m ) {next};
            my $veca = @$a[$m]->FractionalXYZ->X - @$a[$n]->FractionalXYZ->X;
            my $vecb = @$a[$m]->FractionalXYZ->Y - @$a[$n]->FractionalXYZ->Y;
            my $vecc = @$a[$m]->FractionalXYZ->Z - @$a[$n]->FractionalXYZ->Z;
            #performing pbc condition
            if($veca>0.5){$veca-=1};
            if($veca<-0.5){$veca+=1};
            if($vecb>0.5){$vecb-=1};
            if($vecb<-0.5){$vecb+=1};
            if($vecc>0.5){$vecc-=1};
            if($vecc<-0.5){$vecc+=1};
            #transport the displacement vector to Cartersian coordination
            my $dx = $veca*$vec[0]+$vecb*$vec[1]+$vecc*$vec[2];
            my $dy = $veca*$vec[3]+$vecb*$vec[4]+$vecc*$vec[5];
            my $dz = $veca*$vec[6]+$vecb*$vec[7]+$vecc*$vec[8];
            my $ds = $dx**2 + $dy**2 + $dz**2;
            if ($ds < $dmin2){
                #apply weighting function 2/d^-4
                my $dss = sqrt($ds);
                $de += 1; 
                $adx[$m] += $A/$dss**$N*$dx;
                $ady[$m] += $A/$dss**$N*$dy;
                $adz[$m] += $A/$dss**$N*$dz;}
                    };

    #displace atoms by displacement vector
    for(my $m=0; $m<$a->Count; ++$m){
        @$a[$m]->X +=  $adx[$m]*$dd;
        @$a[$m]->Y +=  $ady[$m]*$dd;
        @$a[$m]->Z +=  $adz[$m]*$dd;
        $itr += 1;
        #if iretation steps reaching $maxitr, break this function and you should check relative parameters
        if($itr > $maxitr){
            last}
        }}    
        }        