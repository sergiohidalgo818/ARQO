#!/bin/bash
#
#$ -S /bin/bash
#$ -cwd
#$ -o salida.out
#$ -j y
# Anadir valgrind y gnuplot al path
export PATH=$PATH:/share/apps/tools/valgrind/bin:/share/apps/tools/gnuplot/bin
# Indicar ruta librerías valgrind
export VALGRIND_LIB=/share/apps/tools/valgrind/lib/valgrind

let N1=1024

touch slow.dat
touch fast.dat

#1+1024
for (( i=1; i<=3; i++ ))
do
N1=$((1024 + N1*i))

valgrind --tool=cachegrind --LL=8192 --cachegrind-out-file=cachegrind.out.%p ../material_P3/./slow $N1 | ((callgrind_annotate | head -n 30)>slow.dat) 
name=$(grep D1\ cache: slow.dat | awk '{print $3}')

touch cache_$name.dat

valgrind --tool=cachegrind --cachegrind-out-file=cachegrind.out.%p ../material_P3/./fast $N1 | ((callgrind_annotate | head -n 30)>fast.dat)
(echo $N1 && (sed '20q;d' slow.dat | awk '{print $9}') && (sed '20q;d' slow.dat | awk '{print $15}') && (sed '20q;d' fast.dat | awk '{print $9}') && (sed '20q;d' fast.dat | awk '{print $15}')) | echo $(cat $1) >> cache_$name.dat


done
