#!/bin/bash
#this script transfer the direct format POSCAR into Cartesian format
#Usage: d2c.sh inputfile ,the inputfile will be transferd into inputfile.new
#2019/01/28 pony chen
#email:cjchen16s@imr.ac.cn

end=`grep -n " " $1 | tail -1 | awk -F ":" '{print $1}'` #if your POSCAR has some blank columns or velocity columns,
                                                         #set the varlue end by yourself
#end     

grep -in "Sel" $1 && constr=0 || constr=1;
grep -in "direct" $1 && dire=0 || dire=1;

if [ $dire -eq 0 ];then
	if [ $constr -eq 1 ]; then
		begin=9
		hed=$(($begin-1))
		head -n $hed $1 | cat - > $1.new

		awk -v begin=$begin -v end=$end '
		   NR>=3 && NR<=5 {r[NR]=$1;s[NR]=$2;t[NR]=$3}
		   NR>=begin && NR<=end {x0[NR]=$1;y0[NR]=$2;z0[NR]=$3}
	       END{for(i=begin;i<=end;i=i+1){
		        x1[i]=x0[i]*r[3] + y0[i]*r[4] + z0[i]*r[5];
				y1[i]=x0[i]*s[3] + y0[i]*s[4] + z0[i]*s[5];
				z1[i]=x0[i]*t[3] + y0[i]*t[4] + z0[i]*t[5];
				printf("%9.6f\t%9.6f\t%9.6f\n",x1[i],y1[i],z1[i])
			};
		}' $1 >> $1.new
		sed -i '8c Cartesian' $1.new
	else
		begin=10
		hed=$(($begin-1))
		head -n $hed $1 | cat - > $1.new

		awk -v begin=$begin -v end=$end '
		   NR>=3 && NR<=5 {r[NR]=$1;s[NR]=$2;t[NR]=$3}
		   NR>=begin && NR<=end {x0[NR]=$1;y0[NR]=$2;z0[NR]=$3;u0[NR]=$4;v0[NR]=$5;w0[NR]=$6}
	       END{for(i=begin;i<=end;i=i+1){
		        x1[i]=x0[i]*r[3] + y0[i]*r[4] + z0[i]*r[5];
				y1[i]=x0[i]*s[3] + y0[i]*s[4] + z0[i]*s[5];
				z1[i]=x0[i]*t[3] + y0[i]*t[4] + z0[i]*t[5];
				u1[i]=u0[i];
				v1[i]=v0[i];
				w1[i]=w0[i];
				printf("%9.6f\t%9.6f\t%9.6f\t\t%s\t%s\t%s\n",x1[i],y1[i],z1[i],u1[i],v1[i],w1[i]);
			}
		}' $1 >> $1.new
        sed -i '9c Cartesian' $1.new
	fi
else
	echo " Your file was already in Cartesian format"
fi


    

