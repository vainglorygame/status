set title "processor performance"
set timefmt "%Y-%m-%dT%H:%M:%SZ";
set xdata time;
set ytics nomirror;
set ylabel "transaction duration in ms";
set yrange [ 0:300 ];
set y2tics;
set y2label "number of transactions within 3h";
set y2range [ 0:3000 ];

set datafile separator ", ";

set terminal png noenhanced;
set key autotitle columnhead;
set output outputfile;
plot inputfile using "date":"duration_mean" with lines axes x1y1, \
     inputfile using "date":"duration_count" with lines axes x1y2;
