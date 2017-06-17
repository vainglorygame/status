set title "API /matches errors"
set timefmt "%Y-%m-%dT%H:%M:%SZ";
set xdata time;

set datafile separator ", ";

set terminal png noenhanced;
set key autotitle columnhead;
set output outputfile;
plot inputfile using "date":"date_count" with lines;
