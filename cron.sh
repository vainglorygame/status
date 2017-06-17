#!/bin/bash

DATA=$(dirname "$0")/data
LOGS="/home/timo/vainsocial/logs/logs/pm2"
mkdir -p $DATA || exit 0

PF=$DATA/apigrabber_processed  # progress file
touch $PF $PF.csv
find $LOGS -name "apigrabber-out*__????-??-??_??-??-??.log"\
    | sort\
    | comm -13 $PF - \
    | tee -a $PF \
    | xargs grep -h "connection_end"\
    | sed -E 's_^(.*?) - .*? API response _date=\1, _g' \
    | mlr --fs ", " \
          --ocsv \
          put '$date = sec2gmt(gmt2sec($date) // (60*60*3) * (60*60*3));' \
          then cut -f date,connection_end \
          then stats1 -a min,mean,max -f connection_end -g date \
    >> $PF.csv

gnuplot -e "inputfile='$PF.csv'; outputfile='$PF.png';" connection_end_over_time.plt


PF=$DATA/apigrabber_error_processed  # progress file
touch $PF $PF.csv
find $LOGS -name "apigrabber-error*__????-??-??_??-??-??.log"\
    | sort\
    | comm -13 $PF - \
    | tee -a $PF \
    | xargs grep -h " API error "\
    | sed -E 's_^(.*?) - .*? API error _date=\1, _g' \
    | mlr --fs ", " \
          --ocsv \
          put '$date = sec2gmt(gmt2sec($date) // (60*60*3) * (60*60*3));' \
          then cut -f date \
          then stats1 -a count -f date -g date \
    >> $PF.csv

gnuplot -e "inputfile='$PF.csv'; outputfile='$PF.png';" errors_over_time.plt
