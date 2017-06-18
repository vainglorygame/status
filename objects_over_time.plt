set title "processor data"
set timefmt "%Y-%m-%dT%H:%M:%SZ";
set xdata time;
set ylabel "number of objects within 3h";
set autoscale y;

set datafile separator ", ";

set terminal png noenhanced;
set key autotitle columnhead;
set output outputfile;
plot inputfile using "date":"players_count" with lines, \
     inputfile using "date":"matches_count" with lines, \
     inputfile using "date":"telemetries_count" with lines;
