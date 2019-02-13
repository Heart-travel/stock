#!/bin/bash

ROOT=~/Sources/stock
DATA=${ROOT}/data
RESULT=${ROOT}/result
SCRIPTS=${ROOT}/scripts
STOCK_FILE=${ROOT}/source/stock.txt

while read line
do
	DATE=`echo ${line} | awk '{print $1}'`
	CLOSE=`echo ${line} | awk '{print $2}'`
	OPEN=`echo ${line} | awk '{print $3}'`

	SOURCE="${DATE} ${CLOSE}"
	DEST="${DATE} ${CLOSE} ${OPEN}"

	echo ${SOURCE} ${DEST}

	sed -i "s/${SOURCE}/${DEST}/g" ${DATA}/${1}/${1}_pic.txt

done < ${DATA}/${1}/${1}_rush_in_7_days.txt
