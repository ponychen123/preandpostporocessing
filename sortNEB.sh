#!/bin/bash
#this script sort the atoms order between the initial and final states in NEB calculation
#usage: sortNEB.sh initialstate finalstate
#2019/01/26 by pony chen
#email: cjchen16s@imr.ac.cn

end=`grep -n " " $1 | tail -1 | awk -F ":" '{print $1}' ` # some VASP format file generated under windows may not ended 
                                                          # with "\n", then command wc -l will error counted, so this format is more safe
#end=`cat $1 | wc -l` 
#end=                                                     #if your input file have information about velocities or just more blank clomns, please set the value end by yourself

grep -in "Sel" $1 && constr=0 || constr=1;
r0=0.01

if [ $constr -eq 1 ]; then
   begin1=9

   hed=$(($begin1-1))

   head -n $hed $2 | cat - > $2.new

   awk -v begin=$begin1 -v end=$end '
        FILENAME==ARGV[1] && FNR>=begin && FNR<=end {x0[FNR]=$1;y0[FNR]=$2;z0[FNR]=$3} 
	    FILENAME==ARGV[2] && FNR>=begin && FNR<=end {x1[FNR]=$1;y1[FNR]=$2;z1[FNR]=$3}
	    END{for(i=begin;i<=end;i=i+1){
	         rmin=1;
			 for(j=begin;j<=end;j=j+1){
			    r=(x0[i]-x1[j])^2 + (y0[i]-y1[j])^2 + (z0[i]-z1[j])^2;
				if(r<rmin){rmin=r;nr=j}
				};
			x2[i]=x1[nr];y2[i]=y1[nr];z2[i]=z1[nr];
			printf("%9.6f\t%9.6f\t%9.6f\n", x2[i], y2[i], z2[i])
			};
		}' $1 $2 >> $2.new ;
	else
		begin2=10

        hed=$(($begin2-1))

        head -n $hed $2 | cat - > $2.new

        awk -v begin=$begin2 -v end=$end '
           FILENAME==ARGV[1] && FNR>=begin && FNR<=end {x0[FNR]=$1;y0[FNR]=$2;z0[FNR]=$3;s0[FNR]=$4;t0[FNR]=$5;w0[FNR]=$6} 
	       FILENAME==ARGV[2] && FNR>=begin && FNR<=end {x1[FNR]=$1;y1[FNR]=$2;z1[FNR]=$3;s1[FNR]=$4;t1[FNR]=$5;w1[FNR]=$6}
	       END{for(i=begin;i<=end;i=i+1){
	          rmin=1;
			  for(j=begin;j<=end;j=j+1){
			    r=(x0[i]-x1[j])^2 + (y0[i]-y1[j])^2 + (z0[i]-z1[j])^2;
				if(r<rmin){rmin=r;nr=j}
				};
			 x2[i]=x1[nr];y2[i]=y1[nr];z2[i]=z1[nr];s2[i]=s1[nr];t2[i]=t1[nr];w2[i]=w1[nr];
			 printf("%9.6f\t%9.6f\t%9.6f\t\t%s\t%s\t%s\n", x2[i], y2[i], z2[i],s2[i],t2[i],w2[i])
			 };
		 }' $1 $2 >> $2.new ;
	fi

#test usage	
echo $constr
#echo $end

