gnuplot << EOF
    set xlabel "Tamaño matriz"
    set ylabel "Fallos"
    set xrange [1536:*]
    set xtics 32
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
    set xrange [1536:*]
    set xtics 32
    set term png size 1920,720  
    set output "mult_time.png"
    set logscale y 10
    plot 'mult.dat' using 1:3 title 'normal-read' with lines, \
    'mult.dat' using 1:4 title 'normal-write' with lines, \
    'mult.dat' using 1:6 title 'trasp-read' with lines, \
    'mult.dat' using 1:7 title 'trasp-write' with lines
    replot
    quit
EOF
