#!/bin/bash
#2019/04/24 fix a bug in finding the total lines of file
#this script check the atom interdistances , and will tell you the atoms who meets too closely.
#Usage: dist.sh inputfile
#2019/01/29 pony chen
#email:cjchen16s@imr.ac.cn

end=`awk  'NR == 7 {print $1+$2+$3+$4+$5+8}' $1` 
#i beg you has no more than 5 elements, if you have, stantard DFT is not
#suitable for you, you'd better go to learn EMTO..........
r0=0.25
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
		   NR>=3 && NR<=5 {r[NR]=$1;s[NR]=$2;t[NR]=$3}
		   NR>=begin && NR<=end {x0[NR]=$1;y0[NR]=$2;z0[NR]=$3}
	       END{for(i=begin;i<=end;i=i+1){
		        x1[i]=x0[i]*r[3] + y0[i]*r[4] + z0[i]*r[5];
				y1[i]=x0[i]*s[3] + y0[i]*s[4] + z0[i]*s[5];
				z1[i]=x0[i]*t[3] + y0[i]*t[4] + z0[i]*t[5];
		    	};
               for(j=begin;j<end;j=j+1){
				   for(k=j+1;k<=end;k=k+1){
					   m=sqrt((x1[k]-x1[j])^2 + (y1[k]-y1[j])^2 + (z1[k]-z1[j])^2);
					   if ( m < r0 ){
						   printf( " atom %s and atom %s are too close\n",j,k);}
				   };
			   };
		}' $1 
else
	     awk -v begin=$begin -v end=$end -v r0=$r0 '
		         NR>=begin && NR<=end {x1[NR]=$1;y1[NR]=$2;z1[NR]=$3}
			     END{ for(j=begin;j<end;j=j+1){
				         for(k=j+1;k<=end;k=k+1){
					        m=sqrt((x1[k]-x1[j])^2 + (y1[k]-y1[j])^2 + (z1[k]-z1[j])^2);
					        if ( m < r0 ){
						       printf( " atom %s and atom %s are too close\n",j,k);}
				         };
			            };
				 }' $1 ;
fi



