set title "API /matches response times"
set timefmt "%Y-%m-%dT%H:%M:%SZ";
set xdata time;
set ylabel "response time in ms";
set yrange [ 60:1000 ];

set datafile separator ", ";

set terminal png noenhanced;
set key autotitle columnhead;
set output outputfile;
plot inputfile using "date":"connection_end_min" with lines, \
     inputfile using "date":"connection_end_mean" with lines, \
     inputfile using "date":"connection_end_max" with lines;
