#!/bin/bash

ROOT=~/Sources/stock
DATA=${ROOT}/data
RESULT=${ROOT}/result
SCRIPTS=${ROOT}/scripts
STOCK_FILE=${ROOT}/source/stock.txt
CURRENT_DATE=`date +%Y%m%d`
RUSH_SHORT_LIST=${DATA}/rush_file_list.txt
RUSH_LATEST_FILE=${RESULT}/rush_latest_${CURRENT_DATE}.txt

get_rush_short_list(){
	cd ${DATA}
	find . -name *_rush_in_7_days.txt | tee ${RUSH_SHORT_LIST}
}

get_rush_short_list
:> ${RUSH_LATEST_FILE}
while read line
do
	STOCK=`echo ${line} | awk -F"[/]" '{print $2}'`

	if [ "${STOCK}" -lt 602999 ]; then
		BASENAME=`basename ${line}`
		LAST_LINE=`tail -1 ${DATA}/${STOCK}/${BASENAME}`
		LAST_RUSH_DATE=`echo ${LAST_LINE} | awk '{print $1}' | awk -F"[-]" '{print $1$2$3}'`

		#echo ${CURRENT_DATE} ${LAST_RUSH_DATE}
		if [ -z "${LAST_RUSH_DATE}" ]; then
			echo the ${LAST_RUSH_DATE} of ${STOCK} is NULL !!!
			continue
		fi

		DIFF=`expr ${CURRENT_DATE} - ${LAST_RUSH_DATE}`
		if [ "${DIFF}" -lt 2 ];then
			echo -ne "${STOCK}-\c" | tee -a ${RUSH_LATEST_FILE}
		fi
	fi
done < ${RUSH_SHORT_LIST}

rm ${RUSH_SHORT_LIST}
bash ${SCRIPTS}/_push_notification.sh

