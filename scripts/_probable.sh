#!/bin/bash

ROOT=~/Sources/stock
DATA=${ROOT}/data
RESULT=${ROOT}/result
SCRIPTS=${ROOT}/scripts
STOCK_FILE=${ROOT}/source/stock.txt

YES_CLOSE=0
TODAY_CLOSE=0
TOTAL=0
UP=0

calculate() {
	:> ${DATA}/${1}/${1}_cal.txt
	while read line
	do
		#echo $line
		DATE=`echo $line | awk '{print $1}'`
		TODAY_CLOSE=`echo $line | awk '{print $2}'`
		
		DIFF=`echo ${TODAY_CLOSE} - ${YES_CLOSE} | bc`

		if [ `echo "$DIFF > 0" | bc` -eq 1 ]; then
			VAR="->"
			UP=`expr ${UP} + 1`
		else
			VAR="<-"
		fi
		YES_CLOSE=${TODAY_CLOSE}
		TOTAL=`expr ${TOTAL} + 1`
		printf "%s %8s %8s\n" ${DATE} ${TODAY_CLOSE} ${VAR} | tee -a ${DATA}/${1}/${1}_cal.txt
	done < ${DATA}/${1}/${1}_rush.txt

	echo up=${UP} total=${TOTAL}
	PROBABLE=`echo "scale=3;(${UP}/${TOTAL})*100"|bc`
	printf "result: %.2f%%\n" ${PROBABLE}
	echo "$1 UP ${PROBABLE}%" >> ${RESULT}/probable.txt
}

calculate $1

