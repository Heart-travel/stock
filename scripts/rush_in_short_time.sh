#!/bin/bash

ROOT=/home/pi/source/stock
DATA=${ROOT}/data
RESULT=${ROOT}/result
SCRIPTS=${ROOT}/scripts
STOCK_FILE=${ROOT}/source/stock.txt

for stock in `cat ${STOCK_FILE}`
do
	:> ${DATA}/${stock}/${stock}_rush_in_7_days.txt

	while read line
	do
		DATE=`echo ${line} | awk '{print $1}'`
		LINENR=`grep -n ${DATE} ${DATA}/${stock}/${stock}_orig.txt | awk -F ":" '{print $1}'`

		NXINFO=`sed -n "/${DATE}/{n;p;}" ${stock}/${stock}_rush.txt`
		NXDATE=`echo ${NXINFO} | awk '{print $1}'`
		NXLINENR=`grep -n ${NXDATE} ${DATA}/${stock}/${stock}_orig.txt | awk -F ":" '{print $1}'`

		#echo ${DATE} ${LINENR} ${NXDATE} ${NXLINENR}
		if [ -n "${LINENR}" -a -n "${NXLINENR}" ]; then
			DIFF=`expr ${NXLINENR} - ${LINENR}`
			#echo ${DIFF}
			if [ "${DIFF}" -lt 7 ];then
				echo ${NXINFO} | tee -a ${DATA}/${stock}/${stock}_rush_in_7_days.txt
			fi
		fi
	done < ${DATA}/${stock}/${stock}_rush.txt
done
