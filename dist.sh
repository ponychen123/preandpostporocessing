#!/bin/bash
#2019/05/24 add pbc condition,but now only support direct fprmat
#2019/04/24 fix a bug in finding the total lines of file
#this script check the atom interdistances , and will tell you the atoms who meets too closely.
#Usage: dist.sh inputfile
#2019/01/29 pony chen
#email:cjchen16s@imr.ac.cn

end=`awk  'NR == 7 {print $1+$2+$3+$4+$5+8}' $1` 
#i beg you has no more than 5 elements, if you have, stantard DFT is not
#suitable for you, you'd better go to learn EMTO..........
r0=2.00
#r0 is the threshold for the meening of " toooo close"
grep -in "Sel" $1 > /dev/null 2>&1 && constr=0 || constr=1;
grep -in "direct" $1 > /dev/null 2>&1  && dire=0 || dire=1;

if [ $constr != 0 ]; then
		begin=9
else
		begin=10
		end=`expr $end + 1`
fi

if [ $dire -eq 0 ];then


	     awk -v begin=$begin -v end=$end -v r0=$r0 '
		   NR==2 {scal=$1}
		   NR>=3 && NR<=5 {r[NR]=$1*scal;s[NR]=$2*scal;t[NR]=$3*scal}
		   NR>=begin && NR<=end {x0[NR]=$1;y0[NR]=$2;z0[NR]=$3}
	       END{ for(j=begin;j<end;j=j+1){
				   for(k=j+1;k<=end;k=k+1){
				       veca=x0[j]-x0[k];vecb=y0[j]-y0[k];vecc=z0[j]-z0[k]
                       if(veca>0.5){veca-=1}
					   if(veca<-0.5){veca+=1}
					   if(vecb>0.5){vecb-=1}
					   if(vecb<-0.5){vecb+=1}
					   if(vecc>0.5){vecc-=1}
					   if(vecc<-0.5){vecc+=1}
					   x = veca*r[3]+vecb*r[4]+vecc*r[5]
					   y = veca*s[3]+vecb*s[4]+vecc*s[5]
					   z = veca*t[3]+vecb*t[4]+vecc*t[5]
					   m = sqrt(x**2 + y**2 + z**2)
					   if ( m < r0 ){
						   printf( " atom %s (%9.6f %9.6f %9.6f) and atom %s (%9.6f %9.6f %9.6f) are too close\n",j,x0[j],y0[j],z0[j],k,x0[k],y0[k],z0[k]);}
				   };
			   };
		}' $1 
else
	echo "please make sure your POSCAR was in Direct format"
fi



