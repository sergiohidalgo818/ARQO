#!/bin/bash
#
#$ -S /bin/bash
#$ -cwd
#$ -o salida.out
#$ -j y
# Anadir valgrind y gnuplot al path
export PATH=$PATH:/share/apps/tools/valgrind/bin:/share/apps/tools/gnuplot/bin

export GDFONTPATH=/usr/share/fonts/liberation
export GNUPLOT_DEFAULT_GDFONT=LiberationSans-Regular

> time_slow_fast.dat
> time_slow_fast_pre.dat
> temp.dat

let execs=14
let repeats=14
let slow=0
let fast=0
let aux
let N1

#1 & 3
for (( i=1; i<=$repeats; i++ ))
do

N1=1024

for (( j=1; j<$execs; j++ ))
do
	
	((echo N$j.$i $N1 slow && ../material_P3/./slow $N1 | grep time && echo fast && ../material_P3/./fast $N1 | grep time) | echo $(cat $1)) | awk '{print $2, $6, $10}' >> time_slow_fast_pre.dat
	N1=$((1024 + N1))
done


done


N1=1024

for (( j=1; j<$execs; j++ ))
do
    for (( i=1; i<=$repeats; i++ ))
    do
    grep $N1 time_slow_fast_pre.dat | sed "${i}q;d" | awk '{print $2}' > temp.dat
    
    aux=$(cat temp.dat) 
    slow=$(bc <<< "$slow + $aux")

    grep $N1 time_slow_fast_pre.dat | sed "${i}q;d" | awk '{print $3}' > temp.dat
    aux=$(cat temp.dat) 
    fast=$(bc <<< "$fast + $aux")

    done

    slow=$(bc <<< "scale=6; $slow/$repeats") 
    fast=$(bc <<< "scale=6; $fast/$repeats") 

    
	echo "$N1	$slow	$fast" >> time_slow_fast.dat
	N1=$((1024 + N1))

done



#4
gnuplot << EOF
    set xlabel "Tamaño matriz"
    set ylabel "Tiempo de ejecución"
    set term png size 1920,720  
    set xtics 1024
    set output "time_slow_fast.png"
    plot 'time_slow_fast.dat' using 1:2 title 'slow' with lines, \
        'time_slow_fast.dat' using 1:3 title 'fast' with lines
    quit
EOF