#!/bin/bash

while read line
do
	#sed -i '/匹配字符串/s/替换源字符串/替换目标字符串/g' filename
	#echo $DATE $CLOSE $MAX $MIN $OPEN
	DATE=`echo ${line} | awk '{print $1}'`
	CLOSE=`echo ${line} | awk '{print $2}'`
	OPEN=`echo ${line} | awk '{print $3}'`

	SOURCE="${DATE} ${CLOSE}"
	DEST="${DATE} ${CLOSE} ${OPEN}"

	echo ${SOURCE} ${DEST}

	sed -i "s/${SOURCE}/${DEST}/g" ${1}/${1}_pic.txt

done < ${1}/${1}_rush_in_7_days.txt
