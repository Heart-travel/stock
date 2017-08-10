#!/bin/bash

for stock in `cat stock.txt`
do
	#for current in `cat ${stock}/${stock}_rush.txt`
	while read line
	do
		DATE=`echo ${line} | awk '{print $1}'`
		LINENR=`grep -n ${DATE} ${stock}/${stock}_orig.txt | awk -F ":" '{print $1}'`

		NXINFO=`sed -n "/${DATE}/{n;p;}" ${stock}/${stock}_rush.txt`
		NXDATE=`echo ${NXINFO} | awk '{print $1}'`
		NXLINENR=`grep -n ${NXDATE} ${stock}/${stock}_orig.txt | awk -F ":" '{print $1}'`

		#echo ${DATE} ${LINENR} ${NXDATE} ${NXLINENR}
		if [ -n "${LINENR}" -a -n "${NXLINENR}" ]; then
			DIFF=`expr ${NXLINENR} - ${LINENR}`
			#echo ${DIFF}
			if [ "${DIFF}" -lt 7 ];then
				echo ${NXINFO} | tee -a ${stock}/${stock}_rush_in_7_days.txt
			fi
		fi
	done < ${stock}/${stock}_rush.txt
done
