#!/user/bin/bash

let N1=1024
let cache_tam
let slow
let fast
let file=2

> slow.dat
> fast.dat
#1
cache_tam=$((512))
for (( j=1; j<=4; j++ ))
do
cache_tam=$((cache_tam*2))  
> cache_$cache_tam.dat
for (( i=0; i<12; i++ ))
do
N1=$((1024 + 1024*i))


valgrind --tool=cachegrind --LL=8388608,1,64 --I1=$cache_tam,1,64 --D1=$cache_tam,1,64 --cachegrind-out-file=cachegrind.out.%p ../material_P3/./slow $N1
slow=$(ls -Art | tail -n 1)
(cg_annotate $slow | head -n 30) > slow.dat

valgrind --tool=cachegrind --LL=8388608,1,64 --I1=$cache_tam,1,64 --D1=$cache_tam,1,64 --cachegrind-out-file=cachegrind.out.%p ../material_P3/./fast $N1 
fast=$(ls -Art | tail -n 1)
(cg_annotate $fast | head -n 30) > fast.dat




((echo $N1) && (sed '18q;d' slow.dat | awk '{print $9}') && (sed '18q;d' slow.dat | awk '{print $15}') && (sed '18q;d' fast.dat | awk '{print $9}') && (sed '18q;d' fast.dat | awk '{print $15}')) | echo $(cat $1) >> cache_$cache_tam.dat


done
done


gnuplot << EOF
    set xlabel "Tamaño matriz"
    set ylabel "Fallos"
    set term png size 1920,720  
    set xtics 1024
    set output "cache_lectura.png"
    plot 'cache_1024.dat' using 1:2 title 'slow_1024' with lines, \
        'cache_1024.dat' using 1:4 title 'fast_1024' with lines, \
        'cache_2048.dat' using 1:2 title 'slow_2048' with lines, \
        'cache_2048.dat' using 1:4 title 'fast_2048' with lines, \
        'cache_4096.dat' using 1:2 title 'slow_4096' with lines, \
        'cache_4096.dat' using 1:4 title 'fast_4096' with lines, \
        'cache_8192.dat' using 1:2 title 'slow_8192' with lines, \
        'cache_8192.dat' using 1:4 title 'fast_8192' with lines
    quit

EOF

gnuplot << EOF
    set xlabel "Tamaño matriz"
    set ylabel "Fallos"
    set term png size 1920,720  
    set xtics 1024
    set output "cache_escritura.png"
    plot 'cache_1024.dat' using 1:3 title 'slow_1024' with lines, \
        'cache_1024.dat' using 1:5 title 'fast_1024' with lines, \
        'cache_2048.dat' using 1:3 title 'slow_2048' with lines, \
        'cache_2048.dat' using 1:5 title 'fast_2048' with lines, \
        'cache_4096.dat' using 1:3 title 'slow_4096' with lines, \
        'cache_4096.dat' using 1:5 title 'fast_4096' with lines, \
        'cache_8192.dat' using 1:3 title 'slow_8192' with lines, \
        'cache_8192.dat' using 1:5 title 'fast_8192' with lines
    quit
EOF

