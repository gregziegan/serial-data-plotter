# Greg Ziegan (grz5)
# Matt Prosser (mep99)
# Plotting format file. Is reread to refresh live plot

reset
set terminal wxt size 1300,600
set multiplot layout 3,1 title "Accelerometer Data"
set tmargin 2
### Plot x1, y1
set title "X1, Y1 Values"
unset key
stats 'plot.dat' using 1 name "X"
set xlabel "time (ms)"
set ylabel "acceleration mm/s^2"
if (X_max < 10000) {
    set autoscale x
} else {
    set xrange [X_max-10000:X_max]
}
set yrange [0:] 
plot "plot.dat" using 1:2 with lines, "plot.dat" using 1:5 with lines
###

### plot x2, x3 values
set title "Plot x2, x3 values"
unset key
set xlabel "time (ms)"
set ylabel "linear acceleration (mm/s^2)"
if (X_max < 10000) {
    set autoscale x
} else {
    set xrange [X_max-10000:X_max]
}
set yrange [100:200]
plot "plot.dat" using 1:3 with lines, "plot.dat" using 1:4 with lines 
####

### plot y2, y3
set title "Plot y2, y3 values"
unset key
set xlabel "time (ms)"
set ylabel "acc (mm/s^2)"
if (X_max < 10000) {
    set autoscale x
} else {
    set xrange [X_max-10000:X_max]
}
set yrange [100:200] 
plot "plot.dat" using 1:6 with lines, "plot.dat" using 1:7 with lines
###

unset multiplot
pause 0.01  # stepsize
reread
