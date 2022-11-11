gnuplot << EOF
    set xlabel "Tamaño matriz"
    set ylabel "Tiempo de ejecución"
    set term png size 1920,720  
    set xtics 1024
    set output "time_slow_fast_pre.png"
    plot '< sort -nk1 time_slow_fast_pre.dat' using 1:2 title 'slow' with lines, \
        '< sort -nk1 time_slow_fast_pre.dat' using 1:3 title 'fast' with lines
    replot
    quit
EOF

