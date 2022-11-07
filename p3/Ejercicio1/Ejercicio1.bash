#!/user/bin/bash

#1
for (( i=1; i<=10; i++ ))
do

let N1=1024

for (( j=1; j<=10; j++ ))
do
	
	(echo N$j.$i $N1 slow && ../material_P3/./slow $N1 | grep time && echo fast && ../material_P3/./fast $N1 | grep time) | echo $(cat $1) >> time_slow_fast.dat
	N1=$((1024 + N1))
done


done

#3
awk '{print $2, $6, $10}' time_slow_fast.dat > time_slow_fast.dat

#4
gnuplot << EOF
    set xlabel "Tamaño matriz"
    set ylabel "Tiempo de ejecución"
    set term png size 1920,720  
    set xtics 1024
    set output "time_slow_fast.png"
    plot '< sort -nk1 time_slow_fast.dat' using 1:2 title 'slow' with lines, \
        '< sort -nk1 time_slow_fast.dat' using 1:3 title 'slow' with lines
EOF