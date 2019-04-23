#！perl
#xsd2cfg.pl v1.0 
#change $filename to the xsd file in MS, debug it.export the output file and change the extentions from txt to cfg
#this kind of extended cfg file is looked redundancy and dirty, but effeciency. futher will change to a simplified structure
#author: ponychen, 20190423
use strict;
use GetOpt::Long;
use MaterialsScript qw(:all);

my $filename = "CONTCAR";
my $doc = $Documents{"$filename.xsd"};
my $cfg = Documents->New("$filename.txt");
my $lattice = $doc->SymmetryDefinition;

my $atoms = $doc->UnitCell->Atoms;
my @sortedAt = sort {$a->AtomicNumber <=> $b->AtomicNumber} @$atoms;
my $num_atoms = @sortedAt;

$cfg->Append(sprintf "Number of particles = %f \n", $num_atoms);
$cfg->Append(sprintf "A = 1.0 Angstrom (basic length-scale) \n");
$cfg->Append(sprintf "H0(1,1) = %f \n", $lattice->VectorA->X);
$cfg->Append(sprintf "H0(1,2) = %f \n", $lattice->VectorA->Y);
$cfg->Append(sprintf "H0(1,3) = %f \n", $lattice->VectorA->Z);
$cfg->Append(sprintf "H0(2,1) = %f \n", $lattice->VectorB->X);
$cfg->Append(sprintf "H0(2,2) = %f \n", $lattice->VectorB->Y);
$cfg->Append(sprintf "H0(2,3) = %f \n", $lattice->VectorB->Z);
$cfg->Append(sprintf "H0(3,1) = %f \n", $lattice->VectorC->X);
$cfg->Append(sprintf "H0(3,2) = %f \n", $lattice->VectorC->Y);
$cfg->Append(sprintf "H0(3,3) = %f \n", $lattice->VectorC->Z);
$cfg->Append(sprintf ".NO_VELOCITY. \n");
$cfg->Append(sprintf "entry_count = 3 \n");

foreach my $atom (@sortedAt){
    $cfg->Append(sprintf "%f \n", $atom->Mass);
    $cfg->Append(sprintf "%s \n", $atom->ElementSymbol);
    $cfg->Append(sprintf "%f %f %f \n", $atom->FractionalXYZ->X, $atom->FractionalXYZ->Y, $atom->FractionalXYZ->Z);
}	