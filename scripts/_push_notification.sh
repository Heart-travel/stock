#!/bin/bash

source path.sh

numbers=`cat ${SOURCE}`
#while read line
#do
 echo ${numbers}
 bash ~/bin/instapush.sh stock ${numbers}
#done < ${SOURCE}
 bash ~/bin/instapush_finish.sh ${CURRENT_DATE}
