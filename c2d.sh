#!/bin/bash
#this script transfer the Cartesian format POSCAR to Direct format
#usage: ./c2d.sh inputfile
#warning: your x component of first axis must be a none zero value or this script will erro crack
#ponychen
#20190602
#email:18709821294@outlook.com

end=`awk 'NR == 7 {print $1+$2+$3+$4+$5+$6+8}' $1`

grep -in "Sel" $1 > /dev/null 2>&1 && constr=0 || constr=1;
grep -in "direct" $1 > /dev/null 2>&1 && dire=0 || dire=1;

if [ $dire -eq 1 ];then
	if [ $constr -eq 1 ];then
		begin=9
	else
		begin=10
	    end=$(($end+1))
	fi
	hed=$(($begin-1))
	head -n $hed $1 | cat - > $1.new

#transform Cartesian to Direct in awk	
	awk -v begin=$begin -v end=$end '
	    NR==2 {scal=$1}
		NR>=3 && NR<=5 {r[NR]=$1*scal;s[NR]=$2*scal;t[NR]=$3*scal}
		NR>=begin && NR<=end {x0[NR]=$1;y0[NR]=$2;z0[NR]=$3;u0[NR]=$4;v0[NR]=$5;w0[NR]=$6}
	END{A1=s[5]*r[3]-s[3]*r[5];
	    B1=t[5]*r[3]-t[3]*r[5];
		A2=s[4]*r[3]-s[3]*r[4];
		B2=t[4]*r[3]-t[3]*r[4];
		Q=B2*A1-B1*A2;
		k[3]=(A2*r[5]-A1*r[4])/Q;
		l[3]=A1*r[3]/Q;
		m[3]=-A2*r[3]/Q;
		k[2]=(B2*r[5]-B1*r[4])/(-Q);
		l[2]=B1*r[3]/(-Q);
		m[2]=-B2*r[3]/(-Q);
		k[1]=(1-s[3]*k[2]-t[3]*k[3])/r[3];
		l[1]=-(s[3]*l[2]+t[3]*l[3])/r[3];
		m[1]=-(s[3]*m[2]+t[3]*m[3])/r[3];
		for(i=begin;i<=end;i++){
			x1[i]=k[1]*x0[i]+l[1]*y0[i]+m[1]*z0[i];
			y1[i]=k[2]*x0[i]+l[2]*y0[i]+m[2]*z0[i];
			z1[i]=k[3]*x0[i]+l[3]*y0[i]+m[3]*z0[i];
			printf("\t%9.6f\t%9.6f\t%9.6f\t%s\t%s\t%s\n",x1[i],y1[i],z1[i],u0[i],v0[i],w0[i])
			}}' $1 >> $1.new
    if [ $hed -eq 8 ];then
		sed -i '8c Direct' $1.new
	else
		sed -i '9c Direct' $1.new
	fi
else
	echo "your file was already in directional format."
fi



