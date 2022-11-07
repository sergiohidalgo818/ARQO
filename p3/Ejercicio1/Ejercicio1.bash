#!/user/bin/bash

for (( i=1; i<=10; i++ ))
do

let N1=1024

for (( j=1; j<=10; j++ ))
do
	
	(echo N$j.$i $N1 slow && ../material_P3/./slow $N1 | grep time && echo fast && ../material_P3/./fast $N1 | grep time) | echo $(cat $1) >> Ejercicio1-1.txt
	N1=$((1024 + N1))
done


done


