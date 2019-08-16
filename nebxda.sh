#!/bin/bash
#this script get the image and transfer into XDACAR and you can use ovito watching the movie
#usage: nebxda.sh $1   $1 is the number of images
#ponychen
#20190816

end=`awk 'NR == 7 {print $1+$2+$3+$4+$5+8}' 00/POSCAR`
#i beg you has no more than 5 elements

grep -in "Sel" 00/POSCAR > /dev/null 2>&1 && constr=0 || constr=1
grep -in "direct" 00/POSCAR > /dev/null 2>&1 && dire=0 || dire=1

if [ $constr -eq 0 ];then
    begin=10
    end=`expr $end + 1 `
else
	begin=9
fi

head -n 7 00/POSCAR | cat - > XDATCAR

for i in $(seq 0 $(($1+1)))
do
	m=$(($i+1))
	if [ $dire -eq 0 ];then
		echo "Direct configuration=     $m" >> XDATCAR
	else
		echo "Cartesian configuration=      $m" >> XDATCAR
	fi
	if [ $i -eq 0 ] || [ $i -eq $(($1+1)) ];then
        cat 0$i/POSCAR | sed -n "$begin,$end p" | awk '{print $1 "\t" $2 "\t" $3}' | cat - >> XDATCAR
	else
		cat 0$i/CONTCAR | sed -n "$begin,$end p" | awk '{print $1 "\t" $2 "\t" $3}' | cat - >> XDACAR
	fi
done

