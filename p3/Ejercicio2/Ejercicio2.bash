#!/user/bin/bash

let N1=1024

#1
for (( i=1; i<=4; i++ ))
do

valgrind --tool=cachegrind --cachegrind-out-file=cachegrind.out.%p ../material_P3/./slow $N1 | ((callgrind_annotate | head -n 30)>>test.dat) 
name=$(grep D1\ cache: test.dat | awk '{print $3}')
touch cache_$name.dat
echo $N1 && (sed '20q;d' test.dat | awk '{print $9}') && (sed '20q;d' test.dat | awk '{print $15}') 
valgrind --tool=cachegrind --cachegrind-out-file=cachegrind.out.%p ../material_P3/./fast $N1 | ((callgrind_annotate | head -n 30)>>test.dat)
(sed '20q;d' test.dat | awk '{print $9}') && (sed '20q;d' test.dat | awk '{print $15}') 

N1=$((1024 + N1*i))

done
