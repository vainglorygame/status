set title "processor data"
set timefmt "%Y-%m-%dT%H:%M:%SZ";
set xdata time;
set ytics nomirror;
set ylabel "number of telemetry objects within 3h";
set y2tics;
set y2label "number of player/match objects within 3h";

set autoscale;

set datafile separator ", ";

set terminal png noenhanced;
set key autotitle columnhead;
set output outputfile;
plot inputfile using "date":"players_count" with lines axes x1y2, \
     inputfile using "date":"matches_count" with lines axes x1y2, \
     inputfile using "date":"telemetries_count" with lines axes x1y1;
