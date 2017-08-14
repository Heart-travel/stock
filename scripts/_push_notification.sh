#!/bin/bash

ROOT=~/source/stock
DATA=${ROOT}/data
RESULT=${ROOT}/result
CURRENT_DATE=`date +%Y%m%d`
SOURCE=${RESULT}/rush_latest_${CURRENT_DATE}.txt

numbers=`cat ${SOURCE}`
#while read line
#do
 echo ${numbers}
 bash ~/bin/instapush.sh stock ${numbers}
#done < ${SOURCE}
 bash ~/bin/instapush_finish.sh ${CURRENT_DATE}
