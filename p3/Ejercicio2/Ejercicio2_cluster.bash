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


export GDFONTPATH=/usr/share/fonts/liberation
export GNUPLOT_DEFAULT_GDFONT=LiberationSans-Regular

let N1
let cache_tam
let slow
let fast
let file=2
let p=5
let execs

execs=$((1024 + 1024 *(p+1)))

> slow.dat
> fast.dat
#1
cache_tam=$((512))
for (( j=1; j<=4; j++ ))
do
N1=$((1024))
N1=$((N1 + 1024*$p))
cache_tam=$((cache_tam*2))  
> cache_$cache_tam.dat
while (($N1 <= $execs))
do


valgrind --tool=cachegrind --LL=8388608,1,64 --I1=$cache_tam,1,64 --D1=$cache_tam,1,64 --cachegrind-out-file=cachegrind.out.%p ../material_P3/./slow $N1
slow=$(ls -Art | tail -n 1)
(cg_annotate $slow | head -n 30) > slow.dat

valgrind --tool=cachegrind --LL=8388608,1,64 --I1=$cache_tam,1,64 --D1=$cache_tam,1,64 --cachegrind-out-file=cachegrind.out.%p ../material_P3/./fast $N1 
fast=$(ls -Art | tail -n 1)
(cg_annotate $fast | head -n 30) > fast.dat




(((echo $N1) && (sed '18q;d' slow.dat | awk '{print $5}') && (sed '18q;d' slow.dat | awk '{print $8}') && (sed '18q;d' fast.dat | awk '{print $5}') && (sed '18q;d' fast.dat | awk '{print $8}')) | echo $(cat $1)) | sed 's/,//g' >> cache_$cache_tam.dat

N1=$((N1 + 256))

done
done

gnuplot << EOF
    set xlabel "Tamaño matriz"
    set ylabel "Fallos"
    set term png size 1920,720  
    set xtics 1024
    set output "cache_lectura.png"
    plot 'cache_1024.dat' using 1:2 title 'slow-1024' with lines, \
        'cache_1024.dat' using 1:4 title 'fast-1024' with lines, \
        'cache_2048.dat' using 1:2 title 'slow-2048' with lines, \
        'cache_2048.dat' using 1:4 title 'fast-2048' with lines, \
        'cache_4096.dat' using 1:2 title 'slow-4096' with lines, \
        'cache_4096.dat' using 1:4 title 'fast-4096' with lines, \
        'cache_8192.dat' using 1:2 title 'slow-8192' with lines, \
        'cache_8192.dat' using 1:4 title 'fast-8192' with lines
    replot
    quit
EOF

gnuplot << EOF
    set xlabel "Tamaño matriz"
    set ylabel "Fallos"
    set term png size 1920,720  
    set xtics 1024
    set output "cache_escritura.png"
    plot 'cache_1024.dat' using 1:3 title 'slow-1024' with lines, \
        'cache_1024.dat' using 1:5 title 'fast-1024' with lines, \
        'cache_2048.dat' using 1:3 title 'slow-2048' with lines, \
        'cache_2048.dat' using 1:5 title 'fast-2048' with lines, \
        'cache_4096.dat' using 1:3 title 'slow-4096' with lines, \
        'cache_4096.dat' using 1:5 title 'fast-4096' with lines, \
        'cache_8192.dat' using 1:3 title 'slow-8192' with lines, \
        'cache_8192.dat' using 1:5 title 'fast-8192' with lines
    replot
    quit
EOF


