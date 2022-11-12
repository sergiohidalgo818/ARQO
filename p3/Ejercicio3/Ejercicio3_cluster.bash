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
let mul
let tras
let file=2
let p=5
let execs
let t_mul
let t_tras

execs=$((256 + 256 *(p+1)))
> mult.dat
> mul.dat
> tras.dat
#1

N1=$((256 + 256*$p))

while (($N1 <= $execs))
do


valgrind --tool=cachegrind --LL=8388608,1,64 --I1=1024,1,64 --D1=1024,1,64 --cachegrind-out-file=cachegrind.out.%p ./mul $N1 > mul.dat
t_mul=$(grep time mul.dat | awk '{print $3}')
mul=$(ls -Art | tail -n 1) 
(cg_annotate $mul | head -n 30) > mul.dat

valgrind --tool=cachegrind --LL=8388608,1,64 --I1=1024,1,64 --D1=1024,1,64 --cachegrind-out-file=cachegrind.out.%p ./tras $N1 > tras.dat
t_tras=$(grep time tras.dat | awk '{print $3}')
tras=$(ls -Art | tail -n 1)
(cg_annotate $tras | head -n 30) > tras.dat


((echo "$N1 $t_mul" && (sed '18q;d' mul.dat | awk '{print $5}') && (sed '18q;d' mul.dat | awk '{print $8}') && echo "$t_tras" && (sed '18q;d' tras.dat | awk '{print $5}') && (sed '18q;d' tras.dat | awk '{print $8}')) | echo $(cat $1)) | sed 's/,//g' >> mult.dat

N1=$((N1 + 32))


done




gnuplot << EOF
    set xlabel "Tamaño matriz"
    set ylabel "Fallos"
    set term png size 1920,720  
    set output "mult_cache.png"
    plot 'mult.dat' using 1:2 title 'normal-time' with lines, \
    'mult.dat' using 1:5 title 'trasp-time' with lines   
    replot 
    quit
EOF

gnuplot << EOF
    set xlabel "Tamaño matriz"
    set ylabel "Tiempo"
    set term png size 1920,720  
    set output "mult_time.png"
    plot 'mult.dat' using 1:3 title 'normal-read' with lines, \
    'mult.dat' using 1:4 title 'normal-write' with lines, \
    'mult.dat' using 1:6 title 'trasp-read' with lines, \
    'mult.dat' using 1:7 title 'trasp-write' with lines
    replot
    quit
EOF
