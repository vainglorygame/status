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
          then sort -f date \
    >> $PF.csv

gnuplot -e "inputfile='$PF.csv'; outputfile='$PF.png';" $DATA/../connection_end_over_time.plt


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
          then sort -f date \
    >> $PF.csv

gnuplot -e "inputfile='$PF.csv'; outputfile='$PF.png';" $DATA/../errors_over_time.plt


PF=$DATA/processor_processed  # progress file
touch $PF $PF.csv
find $LOGS -name "processor-out*__????-??-??_??-??-??.log"\
    | sort\
    | comm -13 $PF - \
    | tee -a $PF \
    | xargs grep -h " database transaction " \
    | sed -E 's_^(.*?) - .*? database transaction _date=\1, _g' \
    | mlr --fs ", " \
          --ocsv \
          put '$date = sec2gmt(gmt2sec($date) // (60*60*3) * (60*60*3));' \
          then put '$duration = gsub($duration, "ms", "");' \
          then cut -f date,duration \
          then stats1 -a mean,count -f duration -g date \
          then sort -f date \
    | grep -v "1970" \
    >> $PF.csv

gnuplot -e "inputfile='$PF.csv'; outputfile='$PF.png';" $DATA/../transactions_over_time.plt


PF=$DATA/processor_batch_processed  # progress file
touch $PF $PF.csv
find $LOGS -name "processor-out*__????-??-??_??-??-??.log"\
    | sort\
    | comm -13 $PF - \
    | tee -a $PF \
    | xargs grep -h " processing batch " \
    | sed -E 's_^(.*?) - .*? processing batch _date=\1, _g' \
    | mlr --fs ", " \
          --ocsv \
          put '$date = sec2gmt(gmt2sec($date) // (60*60*3) * (60*60*3));' \
          then stats1 -a sum -f players,matches,telemetries -g date \
          then sort -f date \
    | grep -v "1970" \
    >> $PF.csv

gnuplot -e "inputfile='$PF.csv'; outputfile='$PF.png';" $DATA/../objects_over_time.plt
