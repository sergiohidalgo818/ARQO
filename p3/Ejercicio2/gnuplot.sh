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
EOF

